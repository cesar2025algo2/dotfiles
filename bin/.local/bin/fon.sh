#!/bin/bash
# DESC: devuelve la pronunciacion en ingles (IPA) de la palabra de entrada

# Verifica si pasaste una palabra
if [ -z "$1" ]; then
    echo "Uso: fon palabra"
    exit 1
fi

# Consulta la API de Free Dictionary
word=$1
result=$(curl -s "https://api.dictionaryapi.dev/api/v2/entries/en/$word" | jq -r '.[0].phonetics[] | select(.text != null) | .text' | head -n 1)

if [ -z "$result" ]; then
    echo "No se encontró la transcripción para: $word"
else
    echo -e "Word: \033[1;32m$word\033[0m"
    echo -e "IPA:  \033[1;34m$result\033[0m"
    # Opcional: Copia el resultado al portapapeles (necesitas xclip o wl-copy)
    echo -n "$result" | wl-copy 2>/dev/null || echo -n "$result" | xclip -selection clipboard 2>/dev/null
    echo "(Copiado al portapapeles)"
fi
