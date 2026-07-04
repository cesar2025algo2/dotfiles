#!/bin/bash
# ================================================
# Mantenimiento eMMC-friendly - Versión Final
# Optimizado para laptop con 4GB RAM y eMMC 60GB
# ================================================

echo "=== Mantenimiento eMMC-friendly iniciado $(date) ==="

# 1. Thumbnails antiguos (7 días)
echo "→ Limpiando thumbnails antiguos..."
find ~/.cache/thumbnails -type f -atime +7 -delete 2>/dev/null

# 2. Caché de navegadores
echo "→ Limpiando caché de navegadores..."
rm -rf ~/.cache/mozilla/firefox/*/*/cache/* 2>/dev/null
rm -rf ~/.cache/qutebrowser/Cache/* 2>/dev/null

# 3. Journal - Limpieza moderada
echo "→ Limpiando journal viejo..."
journalctl --vacuum-time=2weeks --vacuum-size=80M 2>/dev/null

# 4. Archivos temporales
echo "→ Limpiando temporales..."
find /tmp -type f -atime +3 -delete 2>/dev/null
find /var/tmp -type f -atime +3 -delete 2>/dev/null

echo "=== Mantenimiento finalizado ==="
echo "Puedes ver el log completo en: ~/.cache/mantenimiento.log"


#!/bin/bash
# 1. Limpiar caché de paquetes: deja solo la versión instalada (-rk1)
# Esto es vital para tu SSD de 58GB
# /usr/bin/paccache -rk3

# 2. Limpiar paquetes de programas que ya desinstalaste
# /usr/bin/paccache -ruk0

# 3. Limpiar miniaturas (thumbnails) viejas (más de 15 días) en tu /home
#find ~/.cache/thumbnails -type f -atime +15 -delete 2>/dev/null

# 4. Limpiar el caché de Falkon/Firefox (opcional, pero libera espacio)
# Puedes descomentar la siguiente línea si quieres limpiar caché de navegación:
# rm -rf ~/.cache/falkon/*
