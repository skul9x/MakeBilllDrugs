#!/bin/bash
set -e

echo "Building Linux release..."
FLUTTER_CMD="flutter"
for p in "$HOME/development/flutter/bin/flutter" "$HOME/flutter/bin/flutter" "/opt/flutter/bin/flutter"; do
  if [ -f "$p" ]; then
    FLUTTER_CMD="$p"
    break
  fi
done

$FLUTTER_CMD build linux --release

echo "Setting up debian-pack directory..."
rm -rf debian-pack
mkdir -p debian-pack/DEBIAN
mkdir -p debian-pack/opt/drugs-maker-flutter
mkdir -p debian-pack/usr/bin
mkdir -p debian-pack/usr/share/applications
mkdir -p debian-pack/usr/share/pixmaps

echo "Copying built bundle..."
cp -r build/linux/x64/release/bundle/* debian-pack/opt/drugs-maker-flutter/

echo "Creating launcher wrapper..."
cat << 'EOF' > debian-pack/usr/bin/drugs-maker-flutter
#!/bin/sh
exec /opt/drugs-maker-flutter/drugs_maker "$@"
EOF
chmod +x debian-pack/usr/bin/drugs-maker-flutter

echo "Creating desktop file..."
cat << 'EOF' > debian-pack/usr/share/applications/drugs-maker-flutter.desktop
[Desktop Entry]
Version=1.0.0
Type=Application
Terminal=false
Name=Make a drug bill
Exec=drugs-maker-flutter
Icon=drugs-maker-flutter
Categories=Utility;
EOF
chmod +x debian-pack/usr/share/applications/drugs-maker-flutter.desktop

echo "Creating dummy icon..."
python3 -c "
import base64
png_data = base64.b64decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==')
with open('debian-pack/usr/share/pixmaps/drugs-maker-flutter.png', 'wb') as f:
    f.write(png_data)
"

echo "Creating control file..."
cat << 'EOF' > debian-pack/DEBIAN/control
Package: drugs-maker-flutter
Version: 1.0.0
Section: utils
Priority: optional
Architecture: amd64
Maintainer: Skul9x <skul9x@example.com>
Description: Drugs Maker application rewritten in Flutter.
EOF

echo "Building deb package..."
dpkg-deb --build debian-pack drugs-maker-flutter_1.0.0_amd64.deb

echo "Cleaning up..."
rm -rf debian-pack

echo "Done building deb package!"
