#!/bin/bash
# 1. Limpiar caché de paquetes: deja solo la versión instalada (-rk1)
# Esto es vital para tu SSD de 58GB
# /usr/bin/paccache -rk3

# 2. Limpiar paquetes de programas que ya desinstalaste
# /usr/bin/paccache -ruk0

# 3. Limpiar miniaturas (thumbnails) viejas (más de 15 días) en tu /home
find ~/.cache/thumbnails -type f -atime +15 -delete 2>/dev/null

# 4. Limpiar el caché de Falkon/Firefox (opcional, pero libera espacio)
# Puedes descomentar la siguiente línea si quieres limpiar caché de navegación:
# rm -rf ~/.cache/falkon/*
