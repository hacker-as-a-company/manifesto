#!/usr/bin/env bash
set -euo pipefail

FILE="HACKER_AS_A_COMPANY_MANIFESTO.md"
OUT="docs/HASHES.md"

if [[ ! -f "$FILE" ]]; then
  echo "Manifesto file not found: $FILE" >&2
  exit 1
fi

HASH=$(sha256sum "$FILE" | awk '{print $1}')
DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "Updating $OUT with SHA-256..." >&2

mkdir -p docs

if ! grep -q "HACKER_AS_A_COMPANY_MANIFESTO.md" "$OUT" 2>/dev/null; then
  cat >> "$OUT" <<'EOF'
# Published Hashes

This file records SHA-256 hashes of important project texts for timestamped proof of origin.

---
Concept and manifesto originally created by El Mehdi Oumedlouz (2025)
https://github.com/hacker-as-a-company
Licensed under CC BY-SA 4.0
EOF
fi

{
  echo ""
  echo "- Manifesto (HACKER_AS_A_COMPANY_MANIFESTO.md):"
  echo "  - sha256: $HASH"
  echo "  - timestamp: $DATE (UTC)"
} >> "$OUT"

echo "Recorded SHA-256: $HASH" >&2
