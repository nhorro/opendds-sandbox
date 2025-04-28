#!/bin/bash
set -e

EXAMPLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$EXAMPLE_DIR/build"

cd "$EXAMPLE_DIR"

# Verificar que los ejecutables existan
if [[ ! -x "$BUILD_DIR/publisher" || ! -x "$BUILD_DIR/subscriber" ]]; then
  echo "❌ Error: Los ejecutables no existen en $BUILD_DIR"
  echo "➡️  Asegurate de haber corrido 'cmake .. && make' en el directorio build"
  exit 1
fi

echo "✅ Ejecutables encontrados:"
echo "  - publisher"
echo "  - subscriber"

echo "🚀 Levantando red distribuida OpenDDS con docker-compose..."
docker compose up --remove-orphans
