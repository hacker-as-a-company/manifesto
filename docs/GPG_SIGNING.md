# GPG-Signed Commits

All maintainer commits in this repository should be GPG signed so GitHub can mark them as `Verified`.

## Maintainer key

- **Owner:** Mehdi OUMEDLOUZ <m.oumedlouz@gmail.com>
- **Key ID:** `27E7545B639D243C`
- **Fingerprint:** `6972 8289 2C96 1875 57C4 1D21 27E7 545B 639D 243C`
- **Public key:** `docs/keys/hacker_as_a_company_pubkey.asc`

Import the key locally if you want to verify signed commits:

```bash
gpg --import docs/keys/hacker_as_a_company_pubkey.asc
```

## Signing your commits

If you maintain this repository, configure Git to use your signing key:

```bash
gpg --quick-gen-key "Your Name <your_email>" ed25519 sign 1y
gpg --list-secret-keys --keyid-format=long "your_email"
# copy the KEYID from the previous command
gpg --armor --export <KEYID> > docs/keys/your_pubkey.asc

git config user.name "Your Name"
git config user.email "your_email"
git config user.signingkey <KEYID>
git config commit.gpgsign true
```

The repo contains `scripts/gpg_wrapper.sh`, which tells Git to use the repo-local `.gnupg_repo/` directory so your key material stays inside the project. Keep that directory out of git history (see `.gitignore`).

## Verifying signatures

Once the key is imported, run:

```bash
git log --show-signature -1
```

Git will display `Good signature from ...` for a verified commit.
