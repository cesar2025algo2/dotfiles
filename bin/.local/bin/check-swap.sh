#!/bin/bash

# Verificar cuánto ocupa zram y cuánto ocupa el swap físico en disco
# Obtenemos los valores de /proc/swaps
zram_used=$(grep 'zram' /proc/swaps | awk '{print $4}')
disk_used=$(grep 'mmcblk0p2' /proc/swaps | awk '{print $4}')

# Convertir de KB a MB para mejor lectura
zram_mb=$((zram_used / 1024))
disk_mb=$((disk_used / 1024))

echo "--- Estado de la Memoria Swap ---"
echo "En ZRAM (RAM Comprimida): $zram_mb MB"
echo "En eMMC (Disco Físico):   $disk_mb MB"

if [ "$disk_mb" -gt 0 ]; then
    echo "ALERTA: Se está usando espacio en el disco físico."
else
    echo "ESTADO: Todo el swap está en RAM (zram). Salud de la eMMC: OK."
fi
