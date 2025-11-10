# Repository Guidelines

This repository hosts the Hacker as a Company manifesto, templates, and docs. Follow these guidelines to keep contributions clean, consistent, and verifiable.

## Project Structure & Module Organization
- Root: `HACKER_AS_A_COMPANY_MANIFESTO.md`, `README.md`, `CHARTER.md`, `ORIGIN.md`, `LICENSE`
- Docs (site): `docs/` (e.g., `docs/index.md`, `_config.yml`)
- Templates: `templates/` (contracts, checklists, guides, profiles)
- Scripts: `scripts/` (e.g., `hash_manifesto.sh`)
- GitHub meta: `.github/` (issue/PR templates)

## Build, Test, and Development Commands
- Hash and record manifesto (proof of origin):
  - `./scripts/hash_manifesto.sh`
- Serve docs locally (optional, requires Jekyll):
  - `jekyll serve -s docs -d _site`
- Basic link check (manual):
  - Search for broken links: `rg -n "\]\(http[s]?://"` and verify targets

## Coding Style & Naming Conventions
- Write concise Markdown with clear headings and short lists.
- Use imperative, present tense; professional tone.
- File names: lowercase with hyphens (e.g., `pricing-guide.md`).
- Include the attribution footer at the end of new docs/templates (see `ORIGIN.md`).

## Testing Guidelines
- No code unit tests. Validate by:
  - Running `./scripts/hash_manifesto.sh` after editing the manifesto.
  - Rendering docs locally if changing `docs/`.
  - Checking links and filenames; avoid dead references.

## Commit & Pull Request Guidelines
- Sign commits (GPG) and use clear messages:
  - Example: `docs: add pentest scope checklist`
- One logical change per PR; update related docs/templates.
- PRs must include: purpose, scope, screenshots (if visual), and mention of attribution footer where applicable.
- Follow `CHARTER.md` and `CODE_OF_CONDUCT.md`.

## Security & Legal
- Do not include secrets or client data.
- No illegal operations or instructions under this name.
- Respect licensing: CC BY‑SA 4.0 and mandatory attribution.
