#!/bin/bash
# ============================================================
# build-deb.sh — Build Linux .deb package cho Flutter Desktop
# ============================================================
set -euo pipefail

APP_SLUG="${APP_SLUG:-drugs-maker}"
RELEASE_VERSION="${RELEASE_VERSION:-v1.0}"
ARCH="amd64"

# ── Xác định version ─────────────────────────────────────────
if [[ -z "${APP_VERSION:-}" ]]; then
  # Đọc từ pubspec.yaml: dòng "version: 1.2.3+45"
  RAW=$(grep -E '^version:' pubspec.yaml | head -1 | sed -E 's/^version:[[:space:]]*//')
  APP_VERSION="${RAW%%+*}"   # bỏ phần "+buildNumber"
fi

# Đảm bảo version có ít nhất 3 thành phần (x.y.z) cho Debian control
IFS='.' read -r V1 V2 V3 <<< "${APP_VERSION}.0.0"
DEB_CONTROL_VERSION="${V1}.${V2}.${V3:-0}"

# Tên file theo chuẩn yêu cầu: ${slug}-${version}-linux-amd64.deb
OUTPUT_DEB_FILE="${OUTPUT_DEB_FILE:-${APP_SLUG}-${RELEASE_VERSION}-linux-${ARCH}.deb}"
PACKAGE_NAME="drugs-maker"

echo "╔══════════════════════════════════════════╗"
echo "║   Building .deb  version ${DEB_CONTROL_VERSION}     ║"
echo "║   Output: ${OUTPUT_DEB_FILE}                 ║"
echo "╚══════════════════════════════════════════╝"

# ── 1. Build Flutter Linux release ───────────────────────────
if [[ -z "${SKIP_BUILD:-}" ]]; then
  echo "🔨 Building Flutter Linux release..."
  FLUTTER_CMD="flutter"
  for p in \
    "$HOME/development/flutter/bin/flutter" \
    "$HOME/flutter/bin/flutter" \
    "/opt/flutter/bin/flutter" \
    "/snap/flutter/current/flutter/bin/flutter"; do
    if [[ -f "$p" ]]; then FLUTTER_CMD="$p"; break; fi
  done

  $FLUTTER_CMD build linux --release
else
  echo "⏭️ SKIP_BUILD is set to true. Skipping Flutter build step."
fi

# ── 2. Chuẩn bị cây thư mục Debian ──────────────────────────
echo "📁 Setting up Debian package structure..."
rm -rf debian-pack
mkdir -p debian-pack/DEBIAN
mkdir -p "debian-pack/opt/${PACKAGE_NAME}"
mkdir -p debian-pack/usr/bin
mkdir -p debian-pack/usr/share/applications
mkdir -p debian-pack/usr/share/pixmaps

# ── 3. Copy bundle (build/linux/x64/release/bundle/) ─────────
echo "📋 Copying Flutter bundle..."
cp -r build/linux/x64/release/bundle/. "debian-pack/opt/${PACKAGE_NAME}/"

# ── 4. Launcher wrapper ───────────────────────────────────────
echo "📝 Creating launcher wrapper..."
cat > "debian-pack/usr/bin/${PACKAGE_NAME}" << LAUNCHER
#!/bin/sh
exec /opt/${PACKAGE_NAME}/drugs_maker "\$@"
LAUNCHER
chmod +x "debian-pack/usr/bin/${PACKAGE_NAME}"

# ── 5. .desktop entry ────────────────────────────────────────
echo "🖥️  Creating .desktop entry..."
cat > "debian-pack/usr/share/applications/${PACKAGE_NAME}.desktop" << DESKTOP_EOF
[Desktop Entry]
Version=${DEB_CONTROL_VERSION}
Type=Application
Terminal=false
Name=Drugs Maker
Comment=Drugs Maker Flutter Desktop Application
Exec=${PACKAGE_NAME}
Icon=${PACKAGE_NAME}
Categories=Office;Utility;
StartupWMClass=drugs_maker
DESKTOP_EOF
chmod +x "debian-pack/usr/share/applications/${PACKAGE_NAME}.desktop"

# ── 6. Icon placeholder (1×1 PNG) ────────────────────────────
echo "🖼️  Generating placeholder icon..."
python3 - << 'PYEOF'
import base64
png = base64.b64decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk'
    '+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg=='
)
with open('debian-pack/usr/share/pixmaps/drugs-maker.png', 'wb') as f:
    f.write(png)
PYEOF

# ── 7. DEBIAN/control ────────────────────────────────────────
echo "📄 Writing DEBIAN/control..."
INSTALLED_SIZE=$(du -sk "debian-pack/opt/${PACKAGE_NAME}" | awk '{print $1}')

cat > debian-pack/DEBIAN/control << CONTROL_EOF
Package: ${PACKAGE_NAME}
Version: ${DEB_CONTROL_VERSION}
Section: utils
Priority: optional
Architecture: ${ARCH}
Installed-Size: ${INSTALLED_SIZE}
Maintainer: Drugs Maker <support@example.com>
Description: Drugs Maker — Trình quản lý hóa đơn thuốc (Flutter Desktop)
 Ứng dụng desktop đa nền tảng quản lý hóa đơn thuốc với giao diện
 Glassmorphism cao cấp.
CONTROL_EOF

# ── 8. Build .deb ─────────────────────────────────────────────
echo "📦 Building .deb package: ${OUTPUT_DEB_FILE}"
dpkg-deb --build --root-owner-group debian-pack "${OUTPUT_DEB_FILE}"

# ── 9. Cleanup ────────────────────────────────────────────────
echo "🧹 Cleaning up..."
rm -rf debian-pack

echo ""
echo "✅ Done! Package created: ${OUTPUT_DEB_FILE}"
