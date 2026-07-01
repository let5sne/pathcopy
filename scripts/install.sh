#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP_SOURCE="$ROOT/dist/PathCopy.app"
APP_TARGET="/Applications/PathCopy.app"
DERIVED_DATA="${DERIVED_DATA:-/tmp/FinderPathCopyDerivedData}"
EXTENSION_ID="com.yuanjiantsui.finderpathcopy.findersync"

if [[ ! -d "$APP_SOURCE" ]]; then
  "$ROOT/scripts/build.sh"
fi

rm -rf "$APP_TARGET"
ditto --noextattr --norsrc "$APP_SOURCE" "$APP_TARGET"
xattr -cr "$APP_TARGET"
codesign --verify --deep --strict --verbose=2 "$APP_TARGET"

/System/Library/Frameworks/CoreServices.framework/Versions/Current/Frameworks/LaunchServices.framework/Versions/Current/Support/lsregister -f -R -trusted "$APP_TARGET"
if [[ -d "$DERIVED_DATA/Build/Products/Release/PathCopy.app/Contents/PlugIns/PathCopyFinderExtension.appex" ]]; then
  pluginkit -r "$DERIVED_DATA/Build/Products/Release/PathCopy.app/Contents/PlugIns/PathCopyFinderExtension.appex" || true
fi
pluginkit -a "$APP_TARGET/Contents/PlugIns/PathCopyFinderExtension.appex" || true
pluginkit -e use -i "$EXTENSION_ID" || true

echo "Installed: $APP_TARGET"
echo "Finder extension: $EXTENSION_ID"
