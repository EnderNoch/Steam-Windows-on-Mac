#!/bin/zsh
# Turns an empty Sikarugir wrapper into Steam for Windows.
#
#   ./setup.sh install   puts the Steam installer in the wrapper; then open the wrapper and click through it
#   ./setup.sh finish    runs Steam instead of the installer, shows the app in the Dock, sets the icon and Retina
#   ./setup.sh settings  copies settings, artwork and collections from Steam for Mac (quit both Steams first)
#
# The wrapper path can be given as the second argument; default is the one Sikarugir Creator makes.
set -e

APP="${2:-$HOME/Applications/Sikarugir/Steam Windows.app}"
PLIST="$APP/Contents/Info.plist"
DRIVE_C="$APP/Contents/drive_c"
STEAM_DIR="$DRIVE_C/Program Files (x86)/Steam"
HERE="${0:A:h}"

[[ -f "$PLIST" ]] || { echo "No wrapper at: $APP"; exit 1; }

# macOS keeps the old icon and Dock flag until the app is registered again
refresh() {
	touch "$APP"
	/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APP"
}

case "$1" in
install)
	curl -fsSL -o "$DRIVE_C/SteamSetup.exe" https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe
	plutil -replace "Program Name and Path" -string "/SteamSetup.exe" "$PLIST"
	echo "Open \"$APP\" and click through the installer. Untick \"Run Steam\" at the end, then run: ./setup.sh finish"
	;;
finish)
	[[ -f "$STEAM_DIR/Steam.exe" ]] || { echo "Steam is not installed yet — run ./setup.sh install first."; exit 1; }
	plutil -replace "Program Name and Path" -string "/Program Files (x86)/Steam/Steam.exe" "$PLIST"
	rm -f "$DRIVE_C/SteamSetup.exe"
	# Sikarugir makes wrappers background-only; without this flag Steam gets its Dock icon
	plutil -remove NSBGOnly "$PLIST" 2>/dev/null || true
	cp "$HERE/Icon/AppIcon.icns" "$APP/Contents/Resources/AppIcon.icns"
	plutil -replace CFBundleIconFile -string AppIcon "$PLIST"
	# Retina: full screen resolution, Windows text at 200% so it keeps its size (Wine rewrites this on exit, so Steam must be closed)
	REG="$APP/Contents/SharedSupport/prefix"
	if ! grep -q '"RetinaMode"' "$REG/user.reg"; then
		if grep -q '^\[Software\\\\Wine\\\\Mac Driver\]' "$REG/user.reg"; then
			sed -i '' '/^\[Software\\\\Wine\\\\Mac Driver\]/{n;a\
"RetinaMode"="y"
}' "$REG/user.reg"
		else
			printf '\n[Software\\\\Wine\\\\Mac Driver]\n"RetinaMode"="y"\n' >> "$REG/user.reg"
		fi
	fi
	sed -i '' 's/^"LogPixels"=dword:00000060/"LogPixels"=dword:000000c0/' "$REG/user.reg" "$REG/system.reg"
	refresh
	echo "Done. Open \"$APP\" — the first start updates Steam."
	;;
settings)
	MAC="$HOME/Library/Application Support/Steam/userdata"
	for user in "$MAC"/<->(N); do
		id="${user:t}"
		win="$STEAM_DIR/userdata/$id"
		[[ -d "$win" ]] || { echo "Skipping $id: never signed in to Steam for Windows"; continue; }
		backup="$APP:h/steam-windows-settings-backup/$id"
		mkdir -p "$backup" "$win/config/grid" "$win/7/remote"
		cp -R "$win/config" "$win/7" "$backup/"
		# not config.vdf: it holds Mac paths and the login
		cp "$user/config/localconfig.vdf" "$win/config/"
		[[ -d "$user/config/grid" ]] && cp -R "$user/config/grid/." "$win/config/grid/"
		[[ -f "$user/7/remote/sharedconfig.vdf" ]] && cp "$user/7/remote/sharedconfig.vdf" "$win/7/remote/"
		echo "Copied settings for $id (backup in $backup)"
	done
	;;
*)
	echo "Usage: ./setup.sh install | finish | settings [wrapper.app]"
	exit 1
	;;
esac
