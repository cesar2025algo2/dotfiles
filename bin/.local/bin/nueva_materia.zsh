#!/usr/bin/env zsh

# Script para crear una nueva materia en el vault
# Uso: ./nueva_materia.zsh "Nombre de la Materia"

if [ $# -eq 0 ]; then
    echo "❌ Uso: ./nueva_materia.zsh 'Nombre de la Materia'"
    exit 1
fi

MATERIA=$1
VAULT_ROOT="${HOME}/Documents/UNCUYO"
CURRENT_YEAR=$(date +%Y)
CURRENT_SEMESTER="1C"  # Cambiar según corresponda

# Crear directorios
MATERIA_DIR="$VAULT_ROOT/2_Materias/${CURRENT_YEAR}-${CURRENT_SEMESTER}/$MATERIA"
mkdir -p "$MATERIA_DIR/Practicos"
mkdir -p "$MATERIA_DIR/Parciales"
mkdir -p "$MATERIA_DIR/Codigo"

# Copiar template
cp "$VAULT_ROOT/5_Templates/Template_Materia.md" "$MATERIA_DIR/00_Resumen.md"

# Reemplazar placeholders
sed -i "s/{{materia}}/$MATERIA/g" "$MATERIA_DIR/00_Resumen.md"
sed -i "s/{{semestre}}/${CURRENT_YEAR}-${CURRENT_SEMESTER}/g" "$MATERIA_DIR/00_Resumen.md"

echo "✅ Materia '$MATERIA' creada en: $MATERIA_DIR"
