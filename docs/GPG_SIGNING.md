# GPG-Signed Commits

This project encourages signed commits for cryptographic authorship.

## Quick Setup (script)

Run the helper script (ed25519 key, no passphrase):

```
NAME="El Mehdi Oumedlouz" EMAIL="m.oumedlouz@gmail.com" ./scripts/gpg_setup_and_sign.sh
```

What it does:
- Generates a signing key (if missing) and exports it to `docs/keys/hacker_as_a_company_pubkey.asc`.
- Configures git to sign commits and tags in this repo.
- Creates a signed seed commit (if changes are staged).

Upload the exported public key to GitHub → Settings → SSH and GPG keys → New GPG key, then push.

## Manual Steps

1) Generate a key:
```
gpg --quick-gen-key "Your Name <your_email>" ed25519 sign 1y
```
2) Find key ID:
```
gpg --list-secret-keys --keyid-format=long "your_email"
```
3) Export public key:
```
gpg --armor --export <KEYID> > docs/keys/your_pubkey.asc
```
4) Configure git:
```
git config user.name "Your Name"
git config user.email "your_email"
git config user.signingkey <KEYID>
git config commit.gpgsign true
```

If pinentry prompts fail, install `pinentry-curses` and ensure a proper TTY.
