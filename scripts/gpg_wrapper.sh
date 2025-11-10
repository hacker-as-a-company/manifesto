#!/usr/bin/env bash
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
export GNUPGHOME="$ROOT/.gnupg_repo"
exec gpg "$@"
