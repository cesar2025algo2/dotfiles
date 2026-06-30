#!/usr/bin/env zsh

# ============================================
# Script para crear estructura de Vault UNCuyo
# ============================================

# Configuración
VAULT_ROOT="${HOME}/Documents/UNCUYO"
CURRENT_YEAR=$(date +%Y)
CURRENT_SEMESTER="1C"  # Cambiar a 2C según corresponda

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "${BLUE}📚 Creando Vault para Ciencias de la Computación - UNCuyo${NC}"
echo "${YELLOW}📁 Ruta: ${VAULT_ROOT}${NC}"
echo ""

# ============================================
# 1. Crear estructura de directorios
# ============================================

echo "${GREEN}▶ Creando directorios...${NC}"

# Directorios principales
directories=(
    "$VAULT_ROOT/0_Inbox"
    "$VAULT_ROOT/1_Recursos"
    "$VAULT_ROOT/2_Materias/${CURRENT_YEAR}-${CURRENT_SEMESTER}"
    "$VAULT_ROOT/3_Trabajos"
    "$VAULT_ROOT/4_Examenes"
    "$VAULT_ROOT/5_Templates"
)

for dir in "${directories[@]}"; do
    mkdir -p "$dir"
    echo "  ✓ ${dir#$VAULT_ROOT/}"
done

# ============================================
# 2. Crear archivos de ejemplo
# ============================================

echo ""
echo "${GREEN}▶ Creando archivos base...${NC}"

# Inbox - nota diaria con fecha
INBOX_FILE="$VAULT_ROOT/0_Inbox/$(date +%Y-%m-%d)_Nota_Rapida.md"
cat > "$INBOX_FILE" << 'EOF'
---
created: $(date +%Y-%m-%d)
tags: [inbox, pendiente]
---

# Nota Rápida - $(date +%d/%m/%Y)

## Ideas
- 

## Dudas
- 

## Recordatorios
- 
EOF
echo "  ✓ 0_Inbox/$(basename $INBOX_FILE)"

# Recursos - Git Cheatsheet
cat > "$VAULT_ROOT/1_Recursos/Git_Cheatsheet.md" << 'EOF'
---
tags: [git, herramientas, referencia]
---

# Git Cheatsheet

## Comandos básicos
git init
git add .
git commit -m "mensaje"
git push origin main

## Ramas
git branch          # listar
git checkout -b nueva # crear y cambiar
git merge feature   # fusionar

## Deshacer cambios
git restore archivo     # descartar cambios
git reset --hard HEAD~1 # deshacer commit
EOF
echo "  ✓ 1_Recursos/Git_Cheatsheet.md"

# Recursos - Linux Tips
cat > "$VAULT_ROOT/1_Recursos/Linux_Tips.md" << 'EOF'
---
tags: [linux, terminal, referencia]
---

# Linux Tips para Computación

## Comandos útiles
- `htop` - monitoreo de procesos
- `ncdu` - análisis de espacio en disco
- `ripgrep` - búsqueda rápida: `rg "patrón"`

## Permisos
chmod +x script.sh
chown usuario:grupo archivo

## Procesos
ps aux | grep proceso
kill -9 PID
EOF
echo "  ✓ 1_Recursos/Linux_Tips.md"

# ============================================
# 3. Crear estructura de materias de ejemplo
# ============================================

echo ""
echo "${GREEN}▶ Creando carpetas de materias de ejemplo...${NC}"

# Lista de materias típicas del primer año
materias=(
    "Matematica_Discreta"
    "Algoritmos_2"
    "Sistemas_Operativos"
)

for materia in "${materias[@]}"; do
    MATERIA_DIR="$VAULT_ROOT/2_Materias/${CURRENT_YEAR}-${CURRENT_SEMESTER}/$materia"
    
    # Crear subdirectorios
    mkdir -p "$MATERIA_DIR/Practicos"
    mkdir -p "$MATERIA_DIR/Parciales"
    mkdir -p "$MATERIA_DIR/Codigo"
    
    # Crear 00_Resumen.md
    cat > "$MATERIA_DIR/00_Resumen.md" << EOF
---
materia: $materia
semestre: ${CURRENT_YEAR}-${CURRENT_SEMESTER}
status: "En curso"
---

# Resumen - $materia

## Temario
1. Tema 1
2. Tema 2
3. Tema 3

## Links útiles
- [Google](https://google.com)
- [UNCuyo](https://uncuyo.edu.ar)

## Fechas importantes
- Parcial 1: 
- Parcial 2: 
- Final: 
EOF
    
    # Crear un tema de ejemplo
    cat > "$MATERIA_DIR/01_Introduccion.md" << EOF
---
materia: $materia
tema: "Introducción"
---

# Tema 1: Introducción

## Conceptos fundamentales

### Definición
> Acá va la definición principal

### Propiedades
- Propiedad 1
- Propiedad 2

### Ejemplo
// Código de ejemplo
int main() {
    printf("Hola Mundo");
    return 0;
}

## Ejercicios
1. Ejercicio 1
2. Ejercicio 2

## Notas adicionales
-
EOF

    # Crear un práctico de ejemplo
    cat > "$MATERIA_DIR/Practicos/Practico_1.md" << EOF
---
materia: $materia
practico: 1
fecha: $(date +%d/%m/%Y)
---

# Práctico 1

## Ejercicios

### Ejercicio 1
**Enunciado:** 
Acá va el enunciado

**Solución:**
// solución

### Ejercicio 2
**Enunciado:** 
Acá va el enunciado

**Solución:**
// solución

## Dificultades encontradas
- 
EOF

    echo "  ✓ 2_Materias/${CURRENT_YEAR}-${CURRENT_SEMESTER}/$materia/"
done

# ============================================
# 4. Crear plantillas (Templates)
# ============================================

echo ""
echo "${GREEN}▶ Creando plantillas...${NC}"

# Template para materias nuevas
cat > "$VAULT_ROOT/5_Templates/Template_Materia.md" << 'EOF'
---
materia: "{{materia}}"
semestre: "{{semestre}}"
status: "En curso"
tags: [materia, universidad]
---

# {{materia}}

## Temario
1. 
2. 
3. 

## Recursos
- Libros:
- Páginas:
- Videos:

## Fechas
- Parcial 1: 
- Parcial 2: 
- Final: 

## Notas
-
EOF

# Template para prácticos
cat > "$VAULT_ROOT/5_Templates/Template_Practico.md" << 'EOF'
---
materia: "{{materia}}"
practico: {{numero}}
fecha: {{fecha}}
tags: [practico, {{materia}}]
---

# Práctico {{numero}}

## Objetivos
- 

## Ejercicios

### Ejercicio 1
**Enunciado:** 

**Solución:**
{{codigo}}

### Ejercicio 2
**Enunciado:** 

**Solución:**
{{codigo}}

## Resumen de conceptos
- 

## Dificultades y aprendizajes
-
EOF

echo "  ✓ 5_Templates/Template_Materia.md"
echo "  ✓ 5_Templates/Template_Practico.md"

# ============================================
# 5. Crear archivo de índice / dashboard
# ============================================

echo ""
echo "${GREEN}▶ Creando dashboard principal...${NC}"

cat > "$VAULT_ROOT/README.md" << EOF
# 🎓 Vault - Licenciatura en Ciencias de la Computación
## Universidad Nacional de Cuyo (UNCuyo)

---

## 📚 Materias ${CURRENT_YEAR}-${CURRENT_SEMESTER}

### En curso
$(for m in "${materias[@]}"; do echo "- [ ] [[2_Materias/${CURRENT_YEAR}-${CURRENT_SEMESTER}/$m/00_Resumen|$m]]"; done)

---

## 📋 Estructura del Vault

- **0_Inbox/** - Notas rápidas y capturas
- **1_Recursos/** - Material permanente (cheatsheets, tips)
- **2_Materias/** - Organizado por año y cuatrimestre
- **3_Trabajos/** - Trabajos prácticos y entregables
- **4_Examenes/** - Exámenes viejos
- **5_Templates/** - Plantillas reutilizables

---

## 🔍 Comandos útiles

- Buscar en todo el vault: \`<C-p>\` (fzf-lua)
- Navegar estructura: \`<leader>e\` (oil.nvim)
- Buscar texto: \`/palabra\` o \`:Telescope live_grep\`

---

## 📝 Notas rápidas

- Última modificación: $(date)
- Materias actuales: ${#materias[@]}
EOF

echo "  ✓ README.md (dashboard)"

# ============================================
# 6. Crear script de utilidad para nuevas materias
# ============================================

echo ""
echo "${GREEN}▶ Creando script de utilidad...${NC}"

cat > "$VAULT_ROOT/nueva_materia.zsh" << 'EOF'
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
EOF

chmod +x "$VAULT_ROOT/nueva_materia.zsh"
echo "  ✓ nueva_materia.zsh (script de utilidad)"

# ============================================
# 7. Crear configuración para Neovim
# ============================================

echo ""
echo "${GREEN}▶ Creando archivo de proyecto para Neovim...${NC}"

cat > "$VAULT_ROOT/.nvim.lua" << 'EOF'
-- Configuración específica para el vault
-- Cargar automáticamente con project.nvim

vim.g.mapleader = " "

-- Configurar fzf-lua para buscar desde la raíz del vault
require('fzf-lua').setup({
    files = {
        cwd = vim.fn.getcwd(),
        prompt = "📁 Files> ",
    },
    grep = {
        cwd = vim.fn.getcwd(),
    },
})

-- Atajos de teclado específicos para el vault
vim.keymap.set("n", "<leader>fi", function()
    require('fzf-lua').files({ cwd = vim.fn.expand("~/Documents/UNCUYO") })
end, { desc = "Buscar en todo el vault" })

vim.keymap.set("n", "<leader>fg", function()
    require('fzf-lua').live_grep({ cwd = vim.fn.expand("~/Documents/UNCUYO") })
end, { desc = "Grep en todo el vault" })

print("🎓 Vault UNCuyo cargado!")
EOF

echo "  ✓ .nvim.lua (config para Neovim)"

# ============================================
# 8. Crear atajo simbólico (opcional)
# ============================================

echo ""
echo "${GREEN}▶ ¿Crear acceso rápido?${NC}"

# Preguntar si quiere crear un alias/symlink
read -q "CREATE_ALIAS?¿Crear symlink ~/vault a ~/Documents/UNCUYO? (s/n) "
echo ""
if [[ $CREATE_ALIAS =~ ^[Ss]$ ]]; then
    ln -sfn "$VAULT_ROOT" "$HOME/vault"
    echo "✅ Symlink creado: ~/vault -> $VAULT_ROOT"
else
    echo "  ⏭  Omitiendo symlink"
fi

# ============================================
# 9. Resumen final
# ============================================

echo ""
echo "${BLUE}========================================${NC}"
echo "${GREEN}✅ ¡Vault creado exitosamente!${NC}"
echo "${BLUE}========================================${NC}"
echo ""
echo "📁 Ubicación: ${YELLOW}$VAULT_ROOT${NC}"
echo ""
echo "🎯 Para comenzar:"
echo "  cd $VAULT_ROOT"
echo "  nvim README.md"
echo ""
echo "🔧 Herramientas disponibles:"
echo "  - ./nueva_materia.zsh 'Nombre'  → crear nueva materia"
echo "  - ~/vault → symlink (si lo creaste)"
echo ""
echo "📚 Materias de ejemplo creadas:"
for m in "${materias[@]}"; do
    echo "  - $m"
done
echo ""
echo "${YELLOW}💡 Tip: Configurá project.nvim para que detecte automáticamente este vault${NC}"
echo "${BLUE}========================================${NC}"
