#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DERIVED_DATA="${DERIVED_DATA:-/tmp/FinderPathCopyDerivedData}"
cd "$ROOT"

for path in PathCopyApp PathCopyFinderExtension FinderPathCopy.xcodeproj project.yml; do
  [[ -e "$path" ]] && xattr -cr "$path"
done
rm -rf "$DERIVED_DATA"

xcodegen generate
xcodebuild \
  -project FinderPathCopy.xcodeproj \
  -scheme PathCopy \
  -configuration Release \
  -derivedDataPath "$DERIVED_DATA" \
  build

rm -rf "$ROOT/dist"
mkdir -p "$ROOT/dist"
ditto --noextattr --norsrc "$DERIVED_DATA/Build/Products/Release/PathCopy.app" "$ROOT/dist/PathCopy.app"
xattr -cr "$ROOT/dist/PathCopy.app"
codesign --verify --deep --strict --verbose=2 "$ROOT/dist/PathCopy.app"

echo "Built: $ROOT/dist/PathCopy.app"
