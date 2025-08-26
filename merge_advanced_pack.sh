#!/usr/bin/env bash
set -euo pipefail

ZIP="mahallamarket-advanced-pack.zip"
TMP=".advpack_tmp"

if [[ ! -f "$ZIP" ]]; then
  echo "❌ Zip not found: $ZIP (place it in the repo root and re-run)"; exit 1;
fi

echo "▶ Unzipping $ZIP to $TMP ..."
rm -rf "$TMP"
unzip -q "$ZIP" -d "$TMP"

echo "▶ Copying files into repo (no deletes)…"
# Don’t clobber git/build/IDE junk
rsync -av "$TMP"/ ./ \
  --exclude '.git' \
  --exclude '.idea' \
  --exclude '.vscode' \
  --exclude 'build' \
  --exclude '.dart_tool'

echo "▶ Cleaning Flutter & fetching deps…"
flutter clean
flutter pub get

# If you have functions in the pack, set them up (no deploy on Spark plan)
if [[ -d "functions" ]]; then
  echo "▶ Installing functions deps (if present)…"
  ( cd functions && npm install --silent || true )
fi

echo "▶ Deploying security rules / indexes (Spark-safe)…"
# Firestore rules & indexes
firebase deploy --only firestore:rules || { echo "⚠️ Firestore rules deploy failed"; }
firebase deploy --only firestore:indexes || { echo "⚠️ Firestore indexes deploy failed"; }

# Storage rules (will fail if Storage not yet enabled in console)
set +e
firebase deploy --only storage:rules
if [[ $? -ne 0 ]]; then
  echo "⚠️ Storage rules skipped. Enable Storage in Firebase Console → Storage → Get Started, then re-run:"
  echo "   firebase deploy --only storage:rules"
fi
set -e

echo "▶ Git commit & push (main)…"
git add -A
git commit -m "Merge advanced pack" || echo "ℹ️ Nothing to commit"
git push origin main || echo "ℹ️ Push skipped/failed (check remote auth)"

echo "✅ Done. Next steps printed below."
echo
echo "=== NEXT ==="
echo "1) Run web on the same port you like:"
echo "   flutter run -d web-server --web-port 40225"
echo
echo "2) If you want an Android APK to test on phone:"
echo "   flutter build apk --release --split-per-abi"
echo "   # APKs appear under build/app/outputs/flutter-apk/"
echo
echo "3) If Storage rules were skipped, enable Storage in the Firebase Console and run:"
echo "   firebase deploy --only storage:rules"
echo
echo "4) If you see location/permission prompts, allow them on device for nearby feed."
