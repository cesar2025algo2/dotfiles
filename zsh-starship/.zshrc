# =================== VARIABLES DE ENTORNO ====================
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
export STARDICT_DATA_DIR="$HOME/.local/share/stardict"
export EDITOR=nvim
export VISUAL=nvim

# ==================== CONFIGURACIÓN DE PANTALLA (Wayland vs X11) ====================
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland
    export XDG_CURRENT_DESKTOP=sway
else
    export MOZ_ENABLE_WAYLAND=0
    export QT_QPA_PLATFORM=xcb
    export XDG_CURRENT_DESKTOP=i3
fi


# =========─── Historia  ───===================
HISTFILE=~/.zsh_history
HISTSIZE=20000
SAVEHIST=20000

# setopt SHARE_HISTORY
# setopt HIST_IGNORE_DUPS
# setopt HIST_IGNORE_SPACE
# setopt HIST_REDUCE_BLANKS
# setopt EXTENDED_HISTORY           # guarda timestamp
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE \
       HIST_REDUCE_BLANKS EXTENDED_HISTORY

# ========─── Colores para ls (Movido aquí para que lo use el completado) ───=========
# Carga los colores por defecto de dircolors (muy recomendado)
if [ -x /usr/bin/dircolors ]; then
    [ -r ~/.dircolors ] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    # if [ -r ~/.dircolors ]; then
    #     eval "$(dircolors -b ~/.dircolors)"
    # else
    #     eval "$(dircolors -b)"
    # fi
fi

# ============─── Completado ───==============
# ─── Case-insensitive para completion y autosuggestions ───
zmodload -i zsh/complist                  # Carga ANTES de compinit (crea menu-select y keymap menuselect)
autoload -Uz compinit
# Inicialización inteligente de compinit (rápida pero se actualiza una vez al día)
if [[ -n ${XDG_CACHE_HOME:-$HOME/.cache}/.zcompdump(#qN.m+1) ]]; then
    compinit
else
    compinit -C
fi

#-------------------
# Comportamiento de completado
setopt list_ambiguous
unsetopt menu_complete

# Configuración del sistema de completado
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}" 'ma=48;5;39;38;5;15;1'  # Colores: fondo turquesa/cian (39 es cyan medio) + texto blanco bold
# Grupos sin títulos raros
zstyle ':completion:*' group-name ''

# =============─── Keybindings ───===============
bindkey '^I' expand-or-complete             # Primer Tab: completa común. Segundo Tab: abre menú.
bindkey '^[[Z' reverse-menu-complete       # Shift-Tab: retrocede
bindkey -M menuselect ' ' accept-line-and-down-history   # Space: acepta + baja en historia (pero sin ejecutar inmediatamente)
bindkey -M menuselect '^M' accept-line                   # Enter: acepta y ejecuta (si ya completó)

# ============─── plugins ───==================
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ==========─── Starship ───============
eval "$(starship init zsh)"

# Prompt simple y limpio (azul para path, verde para prompt)
#PROMP='%F{blue}%~%f %F{green}❯%f '

# ==================== ALIASES GENERALES ====================
# Colores para ls (GNU ls en Arch)
alias ls='ls --color=auto'

# Opcional: aliases útiles con colores
alias ll='ls -l --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'

# sin esto, en sway, geogebra abre una ventana en blanco
alias geogebra='_JAVA_AWT_WM_NONREPARENTING=1 geogebra'

# alias para script que devuelve la fonetica de la palabra ingresada en ingles
alias fon='bash ~/.local/bin/fon.sh'

alias v='nvim'

# Ver el estado de la RAM y zRAM de un vistazo
alias ram='free -h && zramctl'

# Ver cuánto espacio queda en los discos que te importan
alias discos='df -h / /home'

# Ejecutar tu script de limpieza manualmente cuando quieras
alias limpiar='~/.local/bin/mantenimiento.sh'

# chequear swap zram
alias swap-check='~/.local/bin/check-swap.sh'

# muestra info de estado de bateria
alias battery='upower -i /org/freedesktop/UPower/devices/DisplayDevice'

# ==================== FUNCIONES INTERACTIVAS RÁPIDAS ====================
# Captura un color y muestra su codigo hexadecimal en la terminal
pickcolor() {
    local color=$(grim -g "$(slurp -p)" -t ppm - | magick - -format '%[pixel:p{0,0}]\n' txt:- | tail -n 1 | cut -d ' ' -f 4)
    echo "$color"
    echo "$color" | wl-copy # Esto lo copia al portapapeles automáticamente
}

# Diccionario limpio: sin tags HTML, ancho del terminal, fuerza stdin
# Primero borramos el alias viejo para evitar conflictos
unalias def 2>/dev/null

enes() {
    [[ $# -eq 0 ]] && { echo "Uso: def <palabra>"; return 1 }

    local palabra="$1"
    local columnas=$(tput cols)

    {
        # --- Diccionario 1: English-Español (Con formato color y limpieza HTML) ---
        echo -e "\e[1;33m--- Traducción (EN-ES) ---\e[0m"
        sdcv -n -c --utf8-output -u "English-español FreeDict+WikDict dictionary (en-es)" "$palabra" | \
            html2text -b "$columnas" --ignore-links --ignore-images --unicode-snob | \
            sed "s/-->/\x1b[1;36m&/g; s/$/\x1b[0m/"
        
        echo -e "\n" # Espaciador

        # --- Diccionario 2: Longman (Salida cruda o personalizada) ---
        echo -e "\e[1;32m--- Pronunciación (Longman) ---\e[0m"
        # Aquí puedes añadir un sed o un awk específico para Longman si lo deseas
        sdcv -n -c -u "Longman Pronunciation Dictionary 3rd Ed. (En-En)" "$palabra"

        # --- Diccionario 3: (Opcional) Ejemplo de un tercer formato ---
        # echo -e "\n\e[1;35m--- Definición Rápida ---\e[0m"
        # sdcv -n -u "Otro Diccionario" "$palabra" | head -n 10
    } | less -F -X -R
}

esen() {
  [[ $# -eq 0 ]] && { echo "Uso: trad <palabra>"; return 1 }

  # Aquí pones el nombre de tu diccionario ES-EN
  sdcv -n -c --utf8-output -u "Spanish-English FreeDict Dictionary (es-en)" "$@" | \
    html2text -b $(tput cols) --unicode-snob | \
    sed "s/-->/\x1b[1;36m&/g; s/$/\x1b[0m/" | \
    less -F -X -R
}

# YouTube bookmarks (versión corregida)
YT_BOOKMARKS="$HOME/.local/share/youtube/bookmarks.txt"

yt-save() {
    local url="${1:-$(wl-paste 2>/dev/null)}"

    if [[ -z "$url" ]]; then
        echo "No hay URL (ni en el clipboard)"
        return 1
    fi

    echo "Guardando: $url"

    # Extraer título con timeout y opciones más rápidas
    local title
    title=$(timeout 8s yt-dlp --get-title --no-warnings --quiet --force-ipv4 "$url" 2>/dev/null)

    if [[ -z "$title" || "$title" == "ERROR:"* ]]; then
        title="Sin título $(date '+%Y-%m-%d %H:%M')"
    fi

    echo "$url # $title" >> "$YT_BOOKMARKS"
    echo "✓ Guardado: $title"
}

# Ver y reproducir con fzf
# yt-play() {
#     local selection=$(cat "$YT_BOOKMARKS" | fzf --tac --no-sort --exact --prompt="YouTube > " --preview='echo {}' | awk '{print $1}')
#     [[ -n "$selection" ]] && mpv "$selection"
# }

yt-play() {
    local selection=$(cat "$YT_BOOKMARKS" | 
        fzf --tac --no-sort \
            --prompt="YouTube > " \
            --preview='echo {} | cut -d"#" -f2-' \
            --bind 'enter:execute(mpv {1})' \
            | awk '{print $1}')
}

# Ver y descargar
yt-dl-bookmark() {
    local selection=$(cat "$YT_BOOKMARKS" | fzf --tac --no-sort --exact --prompt="Descargar > " | awk '{print $1}')
    [[ -n "$selection" ]] && yt-dlp -f 'bestvideo[height<=1080]+bestaudio/best' "$selection"
}


# =============─── Window titles ───==============
# Para dar nombre a cada ventana
# Función auxiliar para obtener la rama de git actual
get_git_branch() {
  local branch=$(git branch --show-current 2> /dev/null)
  if [ -n "$branch" ]; then
    echo "  $branch"
  fi
}

# 1. Cuando la terminal está libre
precmd() {
  local git_info=$(get_git_branch)
  print -Pn "\e]0;[%1~]$git_info %~\a"
}

# 2. Cuando un programa se está ejecutando
preexec() {
  local cmd_full="$1"
  local cmd="${1%% *}"
  cmd=$(basename "$cmd")
  
  # Lógica de iconos según el tipo de herramienta
  local icon=""
  case "$cmd" in
    nvim|vim|nano)    icon="📝 " ;;
    gcc|g++|make|cargo|python|node) icon="⚙️  " ;;
    zathura|okular)   icon="📖 " ;;
    git)              icon=" " ;;
    *)                icon="🚀 " ;;
  esac
  
  print -Pn "\e]0;$icon$cmd | %1~\a"
}

# 1. Cuando la terminal está libre (muestra el directorio)
# Usamos %1~ para que el nombre de la carpeta actual aparezca PRIMERO
#precmd() {
#  print -Pn "\e]0;[%1~] %~\a"
#}

# 2. Cuando un programa se está ejecutando (muestra el nombre del programa)
#preexec() {
  # $1 es el comando completo (ej: "zathura apunte.pdf")
  # ${1%% *} toma solo la primera palabra (ej: "zathura")
#  local cmd="${1%% *}"
  
  # Si el comando es una ruta completa, nos quedamos solo con el nombre del binario
#  cmd=$(basename "$cmd")
  
#  print -Pn "\e]0;RUN: $cmd | %1~\a"
#}

# ============ Configuracion basica para nnn =================

#export NNN_TERMINAL="foot"          # Fuerza que use foot para cualquier cosa que necesite un terminal nuevo

# nnn basics
#export NNN_FIFO="/tmp/nnn.fifo"      # necesario para previews
#export NNN_PLUG='p:preview-tui;z:fzcd;f:fzfopen;j:autojump;v:imgview;d:dragdrop;t:treeview;'
#export NNN_BMS='d:~/Downloads;D:~/Documentos;c:~/.config;p:~/Proyectos'  # bookmarks (presiona b para ver)

# Colores bonitos + icons (con Nerd Font)
#export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'
#export NNN_ICONLOOKUP=1  # si compilaste nnn con icons, o usa plugin

#alias n="nnn -de"  # -d: no-cd on quit (útil a veces), -e: text en $EDITOR

# export NNN_USE_EDITOR=1  # opcional, pero ponlo en 1 si quieres forzar CLI para texto

# Usa rifle como opener en nnn (recomendado, reutiliza tu config de ranger). Asegúrate de tener rifle instalado (viene con ranger, así que ya lo tienes).

# Corrige NNN_OPTS: combina las flags que sí quieres
export NNN_OPTS="ac"   # 'a' = auto-cd al salir, 'c' = CLI-only opener (útil si quieres evitar algunos GUI fallbacks)
# ¡Esto es lo que activa rifle como opener principal! 
export NNN_OPENER="rifle"
# Opcional pero recomendado: reutiliza el rifle.conf de ranger
export NNN_RIFLE_CONF="$HOME/.config/ranger/rifle.conf"
#alias n="nnn -de"  # descomenta si quieres alias con -d -e

# ==================== SECRETOS / API KEYS ====================
[[ -f ~/.zsh_secrets ]] && source ~/.zsh_secrets

