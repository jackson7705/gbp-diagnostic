#!/usr/bin/env bash
# Install the GBP Diagnostic skill without using the plugin system.
#
#   ./install.sh            symlink into ~/.claude/skills (updates with git pull)
#   ./install.sh --copy     copy instead of symlink
#
# Most people should use the plugin install instead — see README.md.

set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/plugins/gbp-diagnostic/skills/gbp-diagnostic"
DEST="$HOME/.claude/skills/gbp-diagnostic"

[ -d "$SRC" ] || { echo "error: skill not found at $SRC" >&2; exit 1; }

mkdir -p "$HOME/.claude/skills"

if [ -e "$DEST" ] || [ -L "$DEST" ]; then
  echo "Replacing existing install at $DEST"
  rm -rf "$DEST"
fi

if [ "${1:-}" = "--copy" ]; then
  cp -R "$SRC" "$DEST"
  echo "Copied to $DEST"
else
  ln -s "$SRC" "$DEST"
  echo "Linked $DEST -> $SRC"
fi

chmod +x "$(dirname "$SRC")/../scripts/brand.sh" 2>/dev/null || true

cat <<'EOF'

Installed. Restart Claude Code — skills are discovered at startup.

Then run:  /gbp-diagnostic <business name + city, or a Google Maps link>

Your agency branding is asked for once, on first run, and stored at
~/.claude/gbp-diagnostic/brand.json — reinstalling never overwrites it.
EOF
