#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="$ROOT/dist/PathCopy.app"
ZIP="$ROOT/dist/PathCopy.zip"
PACKAGE_ROOT="${TMPDIR:-/tmp}/pathcopy-package.$$"
PACKAGE_APP="$PACKAGE_ROOT/PathCopy.app"

if [[ ! -d "$APP" ]]; then
  "$ROOT/scripts/build.sh"
fi

rm -rf "$PACKAGE_ROOT"
mkdir -p "$PACKAGE_ROOT"
ditto --noextattr --norsrc "$APP" "$PACKAGE_APP"
xattr -cr "$PACKAGE_APP"
codesign --verify --deep --strict --verbose=2 "$PACKAGE_APP"

rm -f "$ZIP" "$ZIP.sha256"
ditto --noextattr --norsrc -c -k --keepParent --zlibCompressionLevel 9 "$PACKAGE_APP" "$ZIP"
(cd "$ROOT/dist" && shasum -a 256 PathCopy.zip > PathCopy.zip.sha256)
rm -rf "$PACKAGE_ROOT"

echo "Packaged: $ZIP"
