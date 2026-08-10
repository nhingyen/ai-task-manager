#!/usr/bin/env bash

set -euo pipefail

echo "==> Configuring Git hooks..."

git config core.hooksPath .githooks

chmod +x .githooks/pre-commit
chmod +x .githooks/pre-push

echo "==> Git hooks configured successfully."