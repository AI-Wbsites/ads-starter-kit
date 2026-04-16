#!/usr/bin/env bash
# sync-wordpress.sh — watch wordpress-theme/ and mirror it to the configured
# destination (usually a local WP install's themes/<slug>/ dir). Destination
# is written to tool/.sync-dest by init.sh, or can be edited by hand.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE="$REPO_ROOT/wordpress-theme"
CONFIG="$SCRIPT_DIR/.sync-dest"

if ! command -v inotifywait >/dev/null 2>&1; then
  echo "✖ inotifywait not found. Install with: sudo apt install inotify-tools" >&2
  exit 1
fi

if ! command -v rsync >/dev/null 2>&1; then
  echo "✖ rsync not found. Install with: sudo apt install rsync" >&2
  exit 1
fi

if [ ! -d "$SOURCE" ]; then
  echo "✖ Source missing: $SOURCE" >&2
  exit 1
fi

if [ ! -f "$CONFIG" ]; then
  echo "✖ No destination configured." >&2
  echo "  Run ./init.sh, or write the destination path into:" >&2
  echo "  $CONFIG" >&2
  exit 1
fi

DEST="$(tr -d '[:space:]' < "$CONFIG")"

if [ -z "$DEST" ]; then
  echo "✖ Destination in $CONFIG is empty." >&2
  exit 1
fi

echo "Source:      $SOURCE"
echo "Destination: $DEST"
echo "Initial sync..."
rsync -av --delete "$SOURCE/" "$DEST/"

echo
echo "Watching for changes. Ctrl+C to stop."
while inotifywait -qq -r -e modify,create,delete,move,close_write "$SOURCE"; do
  rsync -av --delete "$SOURCE/" "$DEST/"
done
