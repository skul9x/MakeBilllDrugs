#!/usr/bin/env bash
# ============================================================
# bump_version.sh — Tự động tăng phiên bản & push tag
#
# Cách dùng:
#   ./bump_version.sh            →  minor bump: 1.0 → 1.1
#   ./bump_version.sh patch      →  patch bump: 1.0 → 1.0.1
#   ./bump_version.sh major      →  major bump: 1.0 → 2.0
#
# Flow:
#   1. Đọc version từ pubspec.yaml
#   2. Tăng version theo loại bump
#   3. Cập nhật pubspec.yaml
#   4. git commit + git tag
#   5. Hỏi có push lên GitHub không
#      → nếu có: GitHub Actions tự động build + release
# ============================================================
set -euo pipefail

PUBSPEC="pubspec.yaml"
BUMP_TYPE="${1:-minor}"

# ── Đọc version hiện tại ──────────────────────────────────────
FULL_VERSION=$(grep -E '^version:' "$PUBSPEC" | head -1 \
               | sed -E 's/^version:[[:space:]]*//')
SEMVER="${FULL_VERSION%%+*}"     # phần trước "+"
BUILD="${FULL_VERSION##*+}"      # phần sau  "+"

# Tách major.minor.patch (thêm .0 nếu chỉ có 2 thành phần)
IFS='.' read -r MAJOR MINOR PATCH <<< "${SEMVER}.0"
PATCH="${PATCH:-0}"

echo "🔖 Version hiện tại : ${SEMVER}  (build: ${BUILD})"

# ── Tính version mới ──────────────────────────────────────────
case "$BUMP_TYPE" in
  major)  MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
  minor)  MINOR=$((MINOR + 1)); PATCH=0 ;;
  patch)  PATCH=$((PATCH + 1)) ;;
  *)
    echo "❌ Loại bump không hợp lệ: '${BUMP_TYPE}'"
    echo "   Dùng: major | minor | patch"
    exit 1 ;;
esac

NEW_BUILD=$((BUILD + 1))

# Bỏ phần .0 ở cuối nếu patch = 0 (1.2.0 → 1.2, nhưng 1.2.3 giữ nguyên)
if [[ "$PATCH" == "0" ]]; then
  NEW_SEMVER="${MAJOR}.${MINOR}"
else
  NEW_SEMVER="${MAJOR}.${MINOR}.${PATCH}"
fi

TAG="v${NEW_SEMVER}"
echo "🚀 Version mới      : ${NEW_SEMVER}  (build: ${NEW_BUILD})  →  tag: ${TAG}"
echo ""

# ── Xác nhận ─────────────────────────────────────────────────
read -r -p "❓ Tiếp tục? (y/N) " CONFIRM
[[ "$CONFIRM" =~ ^[Yy]$ ]] || { echo "↩️  Đã huỷ."; exit 0; }

# ── Kiểm tra working tree sạch (ngoài pubspec.yaml) ──────────
DIRTY=$(git status --porcelain | grep -v "^.. pubspec.yaml" || true)
if [[ -n "$DIRTY" ]]; then
  echo ""
  echo "⚠️  Còn file chưa commit:"
  echo "$DIRTY"
  echo "   Vui lòng commit hoặc stash trước khi bump version."
  exit 1
fi

# ── Cập nhật pubspec.yaml ─────────────────────────────────────
sed -i -E \
  "s|^(version:[[:space:]]*).*|\1${NEW_SEMVER}+${NEW_BUILD}|" \
  "$PUBSPEC"

echo "✅ pubspec.yaml → version: ${NEW_SEMVER}+${NEW_BUILD}"

# ── Git commit + annotated tag ───────────────────────────────
git add "$PUBSPEC"
git commit -m "chore: bump version to ${NEW_SEMVER} [skip ci]"
git tag -a "$TAG" -m "Release ${TAG}"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📌 Đã tạo commit và tag ${TAG} trên local."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Push lên GitHub (trigger CI) ────────────────────────────
read -r -p "🌐 Push commit + tag lên GitHub ngay? (y/N) " PUSH
if [[ "$PUSH" =~ ^[Yy]$ ]]; then
  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  git push origin "$BRANCH"
  git push origin "$TAG"
  echo ""
  echo "🎉 Đã push! GitHub Actions đang build..."
  echo "👉 Actions : https://github.com/skul9x/MakeBilllDrugs/actions"
  echo "📦 Release : https://github.com/skul9x/MakeBilllDrugs/releases/tag/${TAG}"
else
  echo ""
  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  echo "📌 Chưa push. Khi sẵn sàng:"
  echo "   git push origin ${BRANCH} && git push origin ${TAG}"
fi
