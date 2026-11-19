#!/usr/bin/env bash
set -euo pipefail

doc="${1:-EVENT_PAYLOADS.md}"
missing=0
while IFS= read -r event; do
  if ! grep -Fq "\`$event" "$doc"; then
    printf 'Missing event documentation: %s\n' "$event" >&2
    missing=1
  fi
done < <(grep -rhoE 'publish\([[:space:]]*\([[:space:]]*"[A-Za-z0-9_]+' src --include='*.rs' | sed -E 's/.*"//' | sort -u)

if [ "$missing" -ne 0 ]; then exit 1; fi
echo "All emitted event names are documented in $doc."
