#!/bin/bash
# Steam for Windows on a Mac, through a free Sikarugir wrapper. Safe to run again: it skips what is done.

APP="$HOME/Applications/Sikarugir/Steam Windows.app"
CREATOR="/Applications/Sikarugir Creator.app"
ENGINE="WS12WineSikarugir11.0_1"
HERE="$(cd "$(dirname "$0")" && pwd)"
PLIST="$APP/Contents/Info.plist"
PREFIX="$APP/Contents/SharedSupport/prefix"
STEAM="$APP/Contents/drive_c/Program Files (x86)/Steam/Steam.exe"

echo "=== Steam Windows ==="
echo

finish() {
    echo
    read -p "Press Enter to close..."
    exit "$1"
}

running() {
    pgrep -f "Steam Windows.app/Contents/SharedSupport/wine" > /dev/null
}

# 1. Sikarugir Creator
if [ ! -d "$CREATOR" ]; then
    if ! command -v brew > /dev/null; then
        echo "Sikarugir Creator is missing and there is no Homebrew to install it."
        echo "Download it from the page that opens, put it in Applications and run this again."
        open "https://github.com/Sikarugir-App/Sikarugir/releases"
        finish 1
    fi
    echo "Installing Sikarugir Creator..."
    brew trust Sikarugir-App/sikarugir && brew install --cask Sikarugir-App/sikarugir/sikarugir || finish 1
fi

# 2. The wrapper — only Sikarugir Creator can build the Windows inside it
if [ ! -d "$PREFIX/drive_c/windows" ]; then
    echo "In Sikarugir Creator:"
    echo "  1. Pick the engine $ENGINE (Change)."
    echo "  2. Click Create, save as:  Steam Windows.app  in the Sikarugir folder."
    echo
    echo "Waiting for the app..."
    open "$CREATOR"
    until [ -d "$PREFIX/drive_c/windows" ]; do sleep 2; done
    sleep 5
    echo "Got it."
fi

# 3. Steam
if [ ! -f "$STEAM" ]; then
    echo "Downloading the Steam installer..."
    curl -fsSL -o "$APP/Contents/drive_c/SteamSetup.exe" \
        https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe || finish 1
    plutil -replace "Program Name and Path" -string "/SteamSetup.exe" "$PLIST"
    echo
    echo "Click through the Steam installer. At the end untick \"Run Steam\" and click Finish."
    open "$APP"
    until [ -f "$STEAM" ]; do sleep 2; done
    while running; do sleep 2; done
    rm -f "$APP/Contents/drive_c/SteamSetup.exe"
    echo "Steam installed."
fi

if running; then
    echo "Steam Windows is running. Quit it (Steam > Exit), wait until it leaves the Dock,"
    echo "then run this again."
    finish 1
fi

# 4. Run Steam, show in the Dock (Sikarugir makes wrappers background-only), icon
plutil -replace "Program Name and Path" -string "/Program Files (x86)/Steam/Steam.exe" "$PLIST"
plutil -remove NSBGOnly "$PLIST" 2> /dev/null
cp "$HERE/Icon/AppIcon.icns" "$APP/Contents/Resources/AppIcon.icns"
plutil -replace CFBundleIconFile -string AppIcon "$PLIST"

# 5. Retina: full screen resolution, Windows text at 200% so it keeps its size
if ! grep -q '"RetinaMode"' "$PREFIX/user.reg"; then
    if grep -q '^\[Software\\\\Wine\\\\Mac Driver\]' "$PREFIX/user.reg"; then
        sed -i '' '/^\[Software\\\\Wine\\\\Mac Driver\]/{n;a\
"RetinaMode"="y"
}' "$PREFIX/user.reg"
    else
        printf '\n[Software\\\\Wine\\\\Mac Driver]\n"RetinaMode"="y"\n' >> "$PREFIX/user.reg"
    fi
fi
sed -i '' 's/^"LogPixels"=dword:00000060/"LogPixels"=dword:000000c0/' "$PREFIX/user.reg" "$PREFIX/system.reg"

touch "$APP"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APP"

# 6. Optional: a name of its own in Remote Play and Steam Link, so it isn't mixed up with the Mac
NAME="$(scutil --get LocalHostName | tr '[:upper:]' '[:lower:]')-steam-windows"
if ! grep -q "^\"Hostname\"=\"$NAME\"" "$PREFIX/system.reg"; then
    read -p "Add -steam-windows to the name in Remote Play ($NAME)? [y/N] " ANSWER
    if [ "$ANSWER" = "y" ]; then
        # Hostname is the name Steam shows; ComputerName is the old Windows name, 15 characters at most
        sed -i '' -e "s/^\"Hostname\"=\".*\"/\"Hostname\"=\"$NAME\"/" \
            -e 's/^"ComputerName"=".*"/"ComputerName"="STEAM-WINDOWS"/' "$PREFIX/system.reg"
        echo "Renamed."
    fi
fi

# 7. Optional: settings, artwork and collections from Steam for Mac
MAC="$HOME/Library/Application Support/Steam/userdata"
WIN="$(dirname "$STEAM")/userdata"
if [ -d "$MAC" ] && [ -d "$WIN" ] && ! pgrep -x steam_osx > /dev/null; then
    read -p "Copy settings from Steam for Mac? [y/N] " ANSWER
    if [ "$ANSWER" = "y" ]; then
        for USERDIR in "$MAC"/[0-9]*; do
            ID="$(basename "$USERDIR")"
            [ -d "$WIN/$ID" ] || continue
            mkdir -p "$APP/../steam-windows-settings-backup/$ID" "$WIN/$ID/config/grid" "$WIN/$ID/7/remote"
            cp -R "$WIN/$ID/config" "$WIN/$ID/7" "$APP/../steam-windows-settings-backup/$ID/"
            # not config.vdf: it holds Mac paths and the login
            cp "$USERDIR/config/localconfig.vdf" "$WIN/$ID/config/"
            [ -d "$USERDIR/config/grid" ] && cp -R "$USERDIR/config/grid/." "$WIN/$ID/config/grid/"
            [ -f "$USERDIR/7/remote/sharedconfig.vdf" ] && cp "$USERDIR/7/remote/sharedconfig.vdf" "$WIN/$ID/7/remote/"
            echo "Copied for account $ID."
        done
    fi
fi

echo
echo "Done. Open Steam Windows from Applications > Sikarugir."
echo "The first start updates Steam, then sign in."
finish 0
