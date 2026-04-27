#!/bin/zsh

set -euo pipefail

# Si no se pasa argumento, usar carpeta actual
TARGET_DIR="${1:-.}"

# Validar que exista
if [[ ! -d "$TARGET_DIR" ]]; then
  echo "❌ Error: '$TARGET_DIR' no es una carpeta válida"
  exit 1
fi

echo "Renombrando en: $TARGET_DIR"
echo

find "$TARGET_DIR" -depth | while IFS= read -r f; do
  dir=$(dirname "$f")
  base=$(basename "$f")
  lower=$(printf '%s' "$base" | tr '[:upper:]' '[:lower:]')

  if [[ "$base" != "$lower" ]]; then
    target="$dir/$lower"

    if [[ -e "$target" ]]; then
      echo "⚠️  Conflicto: '$target' ya existe. Se omite '$f'"
      continue
    fi

    echo "Renombrando: '$f' → '$target'"
    mv "$f" "$target"
  fi
done

echo
echo "✅ Listo."
