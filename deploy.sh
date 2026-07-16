#!/usr/bin/env bash
set -euo pipefail

MOD_NAME="factory-efficiency-tracker"
MODS_DIR="$HOME/.factorio/mods"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

VERSION=$(grep '"version"' "$SCRIPT_DIR/info.json" | sed 's/.*"version": *"\([^"]*\)".*/\1/')
ZIP_NAME="${MOD_NAME}_${VERSION}.zip"
TMP_DIR=$(mktemp -d)

cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

echo "Packaging $ZIP_NAME..."

mkdir "$TMP_DIR/$MOD_NAME"
rsync -a --exclude='.git' --exclude='.gitignore' --exclude='archive' --exclude='deploy.sh' --exclude='README.md' \
  "$SCRIPT_DIR/" "$TMP_DIR/$MOD_NAME/"

(cd "$TMP_DIR" && zip -qr "$ZIP_NAME" "$MOD_NAME")

rm -f "$MODS_DIR/${MOD_NAME}_"*.zip
cp "$TMP_DIR/$ZIP_NAME" "$MODS_DIR/"

echo "Deployed to $MODS_DIR/$ZIP_NAME"
