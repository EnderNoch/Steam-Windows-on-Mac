#!/bin/bash
# One small app per game installed in Steam Windows, with the game's icon, for Applications and the Dock.
# Run it again after installing a new game.

APP="$HOME/Applications/Sikarugir/Steam Windows.app"
OUT="$HOME/Applications/Steam Windows Games"
STEAMDIR="$APP/Contents/drive_c/Program Files (x86)/Steam"

echo "=== Game shortcuts ==="
echo

if [ ! -d "$STEAMDIR/steamapps" ]; then
    echo "Steam Windows is not installed yet. Run Install Steam Windows.command first."
    echo
    read -p "Press Enter to close..."
    exit 1
fi

mkdir -p "$OUT"
COUNT=0

for MANIFEST in "$STEAMDIR"/steamapps/appmanifest_*.acf; do
    [ -f "$MANIFEST" ] || continue
    ID="$(sed -n 's/^[[:space:]]*"appid"[[:space:]]*"\(.*\)"/\1/p' "$MANIFEST")"
    NAME="$(sed -n 's/^[[:space:]]*"name"[[:space:]]*"\(.*\)"/\1/p' "$MANIFEST" | tr -d '/:')"
    # Steamworks Common Redistributables is not a game
    [ "$ID" = "228980" ] && continue

    GAME="$OUT/$NAME.app"
    mkdir -p "$GAME/Contents/MacOS" "$GAME/Contents/Resources"

    # The wrapper starts Steam with its "Program Flags"; a second copy hands -applaunch to a running Steam
    cat > "$GAME/Contents/MacOS/run" << 'EOF'
#!/bin/sh
# Starts Steam Windows if needed and launches the game in it
APP="__APP__"
PLIST="$APP/Contents/Info.plist"
plutil -replace "Program Flags" -string "-applaunch __ID__" "$PLIST"
open -n "$APP"
# the wrapper reads the flags when it starts; put them back so Steam Windows opens just Steam
sleep 20
plutil -replace "Program Flags" -string "" "$PLIST"
EOF
    sed -i '' -e "s|__APP__|$APP|" -e "s|__ID__|$ID|" "$GAME/Contents/MacOS/run"
    chmod +x "$GAME/Contents/MacOS/run"

    cat > "$GAME/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleName</key><string>$NAME</string>
	<key>CFBundleIdentifier</key><string>com.steamwindows.game$ID</string>
	<key>CFBundleExecutable</key><string>run</string>
	<key>CFBundleIconFile</key><string>icon</string>
	<key>CFBundlePackageType</key><string>APPL</string>
	<key>LSUIElement</key><true/>
</dict>
</plist>
EOF

    # the game's icon: Steam keeps it as steam/games/<hash>.ico, the hash names a jpg in librarycache/<appid>
    HASH="$(basename "$(ls "$STEAMDIR/appcache/librarycache/$ID/"*.jpg 2> /dev/null | head -1)" .jpg)"
    ICO="$STEAMDIR/steam/games/$HASH.ico"
    if [ -n "$HASH" ] && [ -f "$ICO" ]; then
        sips -s format png "$ICO" --out "$GAME/Contents/Resources/icon.png" > /dev/null
        sips -s format icns "$GAME/Contents/Resources/icon.png" --out "$GAME/Contents/Resources/icon.icns" > /dev/null
        rm -f "$GAME/Contents/Resources/icon.png"
    fi

    touch "$GAME"
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$GAME"
    echo "  $NAME"
    COUNT=$((COUNT + 1))
done

echo
echo "$COUNT shortcut(s) in Applications > Steam Windows Games."
open "$OUT"
echo
read -p "Press Enter to close..."
