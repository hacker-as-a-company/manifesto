#!/usr/bin/env bash
set -euo pipefail

# Creates a GPG ed25519 signing key (no passphrase, local dev use),
# stored inside the repository (repo-local keyring), configures git to sign
# commits using a wrapper, makes a signed seed commit, and exports your
# public key to docs/keys/ for GitHub.

NAME=${NAME:-"El Mehdi Oumedlouz"}
EMAIL=${EMAIL:-"m.oumedlouz@gmail.com"}
EXPIRE=${EXPIRE:-"1y"}

REPO_ROOT="$(pwd)"
GNUPG_HOME="$REPO_ROOT/.gnupg_repo"
export GNUPGHOME="$GNUPG_HOME"

if ! command -v gpg >/dev/null 2>&1; then
  echo "gpg is not installed. Install with: sudo apt-get install -y gnupg pinentry-curses" >&2
  exit 1
fi

# Generate key non-interactively if it doesn't exist
mkdir -p "$GNUPG_HOME"
chmod 700 "$GNUPG_HOME"

if ! gpg --list-secret-keys --keyid-format=long "$EMAIL" >/dev/null 2>&1; then
  echo "Generating ed25519 signing key for $EMAIL ..." >&2
  cat > .gpg-genkey.batch <<EOF
%no-protection
Key-Type: eddsa
Key-Curve: ed25519
Key-Usage: sign
Name-Real: ${NAME}
Name-Email: ${EMAIL}
Expire-Date: ${EXPIRE}
%commit
EOF
  gpg --batch --generate-key .gpg-genkey.batch
  rm -f .gpg-genkey.batch
else
  echo "Existing GPG key found for $EMAIL. Skipping generation." >&2
fi

KEYID=$(gpg --list-secret-keys --keyid-format=long "$EMAIL" | awk '/sec/ {print $2}' | sed 's#.*/##' | head -n1)
if [[ -z "${KEYID:-}" ]]; then
  echo "Failed to resolve GPG key ID for $EMAIL" >&2
  exit 1
fi

echo "Using GPG key: $KEYID" >&2

# Export ASCII-armored public key for GitHub
mkdir -p docs/keys
gpg --armor --export "$KEYID" > docs/keys/hacker_as_a_company_pubkey.asc
echo "Exported public key to docs/keys/hacker_as_a_company_pubkey.asc" >&2

# Configure git (per-repo)
if [ ! -d .git ]; then
  git init
fi

# Create gpg wrapper and configure git to use repo-local keyring
mkdir -p scripts
cat > scripts/gpg_wrapper.sh <<'WRAP'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
export GNUPGHOME="$ROOT/.gnupg_repo"
exec gpg "$@"
WRAP
chmod +x scripts/gpg_wrapper.sh

git config user.name "$NAME"
git config user.email "$EMAIL"
git config commit.gpgsign true
git config tag.gpgSign true
git config user.signingkey "$KEYID"
git config gpg.program "$(pwd)/scripts/gpg_wrapper.sh"

git add -A
if ! git diff --cached --quiet; then
  git commit -S -m "Seed: Hacker as a Company (Nov 2025)"
else
  echo "No changes staged; skipping commit." >&2
fi

echo "Signing status (last commit):" >&2
git log --show-signature -1 || true

cat <<MSG >&2

Next steps:
1) Upload docs/keys/hacker_as_a_company_pubkey.asc to GitHub → Settings → SSH and GPG keys → New GPG key.
2) Set remote and push: git branch -M main && git remote add origin <your-repo-url> && git push -u origin main
3) Verify the \"Verified\" badge appears on the commit.
MSG
