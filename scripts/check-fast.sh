#!/usr/bin/env bash

set -euo pipefail

echo "==> Checking Dart formatting..."
dart format --output=none --set-exit-if-changed .

echo "==> Running Flutter analyzer..."
flutter analyze

echo "==> Fast checks passed."