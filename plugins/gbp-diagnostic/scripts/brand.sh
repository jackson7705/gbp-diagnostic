#!/usr/bin/env bash
# Manage the agency brand used on every GBP diagnostic report.
#
#   brand.sh show                       print the current brand
#   brand.sh set "Agency Name" [logo] [#hex] [footer]
#   brand.sh path                       print the brand file location
#
# The agent normally handles this during first-run onboarding. This script
# exists so you can set or change the brand yourself, without a session.

set -euo pipefail

BRAND_DIR="$HOME/.claude/gbp-diagnostic"
BRAND_FILE="$BRAND_DIR/brand.json"

usage() { sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'; exit "${1:-0}"; }

case "${1:-show}" in
  path) echo "$BRAND_FILE" ;;

  show)
    if [ -f "$BRAND_FILE" ]; then
      python3 - "$BRAND_FILE" <<'PY'
import json, sys
b = json.load(open(sys.argv[1]))
logo = b.get("logoDataUri") or ""
size = f"{len(logo)/1024:.1f} KB" if len(logo) >= 1024 else f"{len(logo)} bytes"
print(f'Agency : {b.get("agencyName") or "(unset)"}')
print(f'Accent : {b.get("accentHex") or "#1F3A93"}')
print(f'Footer : {b.get("footer") or "(none)"}')
print(f'Logo   : {"embedded, " + size if logo else "(none — wordmark will be used)"}')
print(f'Updated: {b.get("updatedAt") or "(unknown)"}')
PY
    else
      echo "No brand set. Run: brand.sh set \"Your Agency\" [logo-path] [#hex] [footer]"
      exit 1
    fi
    ;;

  set)
    [ $# -ge 2 ] || usage 1
    NAME="$2"; LOGO="${3:-}"; ACCENT="${4:-#1F3A93}"; FOOTER="${5:-}"
    mkdir -p "$BRAND_DIR"
    DATAURI=""

    if [ -n "$LOGO" ] && [ -f "$LOGO" ]; then
      SRC="$LOGO"
      BYTES=$(wc -c < "$SRC" | tr -d ' ')
      # Downscale heavy raster logos; SVG passes through untouched.
      if [ "$BYTES" -gt 200000 ] && [ "${SRC##*.}" != "svg" ]; then
        if command -v sips >/dev/null 2>&1; then
          sips -Z 600 "$SRC" --out /tmp/gbp-logo.png >/dev/null 2>&1 && SRC=/tmp/gbp-logo.png
        elif command -v convert >/dev/null 2>&1; then
          convert "$SRC" -resize '600x600>' /tmp/gbp-logo.png && SRC=/tmp/gbp-logo.png
        else
          echo "warning: logo is $((BYTES/1024)) KB and no resizer (sips/convert) found; embedding as-is" >&2
        fi
      fi
      case "${SRC##*.}" in
        png)       MIME=image/png ;;
        jpg|jpeg)  MIME=image/jpeg ;;
        svg)       MIME=image/svg+xml ;;
        webp)      MIME=image/webp ;;
        gif)       MIME=image/gif ;;
        *)         echo "error: unsupported logo type '${SRC##*.}'" >&2; exit 1 ;;
      esac
      DATAURI="data:$MIME;base64,$(base64 < "$SRC" | tr -d '\n')"
    elif [ -n "$LOGO" ]; then
      echo "error: logo file not found: $LOGO" >&2; exit 1
    fi

    NAME="$NAME" ACCENT="$ACCENT" FOOTER="$FOOTER" DATAURI="$DATAURI" \
    python3 - "$BRAND_FILE" <<'PY'
import json, os, sys, datetime
json.dump({
    "agencyName":  os.environ["NAME"],
    "logoDataUri": os.environ["DATAURI"],
    "logoAlt":     os.environ["NAME"],
    "accentHex":   os.environ["ACCENT"],
    "footer":      os.environ["FOOTER"],
    "updatedAt":   datetime.date.today().isoformat(),
}, open(sys.argv[1], "w"), indent=2)
PY
    echo "Brand saved to $BRAND_FILE"
    "$0" show
    ;;

  -h|--help|help) usage 0 ;;
  *) usage 1 ;;
esac
