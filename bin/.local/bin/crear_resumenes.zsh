#!/usr/bin/env zsh
# DESC: Script para crear 00_Resumen.md en TODAS las materias de TODOS los cuatrimestres
# ============================================

VAULT="$HOME/uncuyo"  # Ruta raíz de tu vault

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "${BLUE}📚 Creando resúmenes para todas las materias${NC}"
echo ""

# Contadores globales
total_creados=0
total_existentes=0
total_materias=0
total_semestres=0

# Función para crear resumen en una materia
crear_resumen() {
    local materia_dir="$1"
    local nombre_materia=$(basename "$materia_dir")
    local semestre=$(basename "$(dirname "$materia_dir")")
    
    # Ruta del archivo 00_Resumen.md
    local resumen="$materia_dir/00_Resumen.md"
    
    # Verificar si ya existe
    if [[ -f "$resumen" ]]; then
        echo "${YELLOW}  ⏭  $semestre/$nombre_materia: 00_Resumen.md ya existe${NC}"
        ((total_existentes++))
        return
    fi
    
    # Crear el archivo
    echo "${GREEN}  ✓  $semestre/$nombre_materia: creando 00_Resumen.md${NC}"
    
    # Determinar el nombre bonito (reemplazar _ por espacios)
    local nombre_bonito=$(echo "$nombre_materia" | sed 's/_/ /g')
    
    cat > "$resumen" << EOF
---
materia: "$nombre_bonito"
semestre: "$semestre"
status: "En curso"
tags: [materia, $nombre_materia]
fecha_creacion: $(date +%Y-%m-%d)
---

# $nombre_bonito

## 📋 Datos de la materia

- **Semestre:** $semestre
- **Estado:** En curso
- **Última actualización:** $(date +%Y-%m-%d)

---

## 📚 Temario / Unidades

1. [Unidad 01](01-Unidad-01/)
2. [Unidad 02](02-Unidad-02/)
3. [Unidad 03](03-Unidad-03/)
4. [Unidad 04](04-Unidad-04/)
5. [Unidad 05](05-Unidad-05/)
6. [Unidad 06](06-Unidad-06/)

---

## 📝 Recursos

### Bibliografía
- 

### Enlaces útiles
- 

---

## 📅 Fechas importantes

- **Parcial 1:** 
- **Parcial 2:** 
- **Final:** 
- **Trabajos prácticos:** 

---

## 🧠 Conceptos clave (Zettelkasten)

Notas relacionadas en el Zettelkasten:
- [[6_Zettelkasten/]] ← Ver todas las notas

---

## 📝 Notas de clase

### $(date +%Y-%m-%d) - Clase 1
- 

---

## 🔗 Enlaces internos

- [[../README|Volver al dashboard]]
- [[./Codigo/|Código de la materia]]
- [[./Practicos/|Prácticos]]
- [[./Parciales/|Parciales]]

---

*Última modificación: $(date +%Y-%m-%d %H:%M:%S)*
EOF
    
    ((total_creados++))
}

# ============================================
# Recorrer TODOS los cuatrimestres
# ============================================

MATERIAS_BASE="$VAULT/2_Materias"

if [[ ! -d "$MATERIAS_BASE" ]]; then
    echo "${RED}❌ Error: No existe la carpeta $MATERIAS_BASE${NC}"
    exit 1
fi

# Recorrer cada cuatrimestre (carpeta dentro de 2_Materias)
for semestre_dir in "$MATERIAS_BASE"/*/; do
    # Verificar que sea un directorio
    [[ ! -d "$semestre_dir" ]] && continue
    
    semestre=$(basename "$semestre_dir")
    echo "${BLUE}📂 Procesando semestre: $semestre${NC}"
    
    # Verificar si hay materias (subcarpetas)
    # Usar un array para evitar el error "no matches found"
    setopt localoptions nullglob
    materias=("$semestre_dir"/*/)
    
    if [[ ${#materias[@]} -eq 0 ]]; then
        echo "${YELLOW}  ⚠️  No hay materias en este semestre${NC}"
        echo ""
        continue
    fi
    
    # Recorrer cada materia dentro del semestre
    for materia_dir in "${materias[@]}"; do
        [[ ! -d "$materia_dir" ]] && continue
        ((total_materias++))
        crear_resumen "$materia_dir"
    done
    
    echo ""
done

# ============================================
# Resumen final
# ============================================

echo "${BLUE}========================================${NC}"
echo "${GREEN}✅ Resumen completado${NC}"
echo "${BLUE}========================================${NC}"
echo ""
echo "📊 Estadísticas:"
echo "  - Resúmenes creados:   ${GREEN}$total_creados${NC}"
echo "  - Resúmenes existentes: ${YELLOW}$total_existentes${NC}"
echo "  - Total de materias:   $total_materias"
echo ""
echo "📁 Ubicación: $MATERIAS_BASE"

