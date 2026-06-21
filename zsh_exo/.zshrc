# ==================== ENTORNO Y PATH ====================
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
# Agrega tus binarios locales y de NPM al inicio del PATH de forma segura
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
export STARDICT_DATA_DIR="$HOME/.local/share/stardict"
export EDITOR=vim
export VISUAL=vim
export COLORTERM=truecolor


# ==================== OH-MY-ZSH ====================
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"



# # ==================== UNCuyo Cloud Sync ====================
# # Sincronización inteligente con OneDrive UNCuyo
# # ==================== SISTEMA DE REGISTRO DE SINCRONIZACIÓN ====================
# # ==================== SISTEMA DE LOGS UNCuyo ====================
#
# LOCAL_LOG="$HOME/.sync-log-local.txt"      # Log completo (no se sincroniza)
# SYNCED_LOG="$HOME/uncuyo/.sync-log.txt"    # Solo subidas (se sincroniza)
#
# log-local() {
#     local direction=$1
#     echo "$(date '+%Y-%m-%d %H:%M:%S') | $direction | $(hostname) | SUCCESS" >> "$LOCAL_LOG"
# }
#
# log-synced() {
#     local direction=$1
#     echo "$(date '+%Y-%m-%d %H:%M:%S') | $direction | $(hostname) | SUCCESS" >> "$SYNCED_LOG"
# }
#
# # ====================== FUNCIONES DE SYNC ======================
#
# sync-uncuyo-up() {
#     echo "🔼 Subiendo a OneDrive..."
#
#     if [[ "$*" == *"--dry-run"* ]] || [[ "$*" == *"-n"* ]]; then
#         rclone sync ~/uncuyo/ UNCuyo:lcc \
#             --track-renames --create-empty-src-dirs --fast-list -v --progress "$@"
#         echo "🔍 Dry-run - No se registró"
#     else
#         if rclone sync ~/uncuyo/ UNCuyo:lcc \
#             --track-renames --create-empty-src-dirs --fast-list -v --progress "$@"; then
#
#             log-local "UP"
#             log-synced "UP"
#             echo "✅ Subida completada y registrada"
#         else
#             echo "❌ Error en la subida"
#         fi
#     fi
# }
#
# sync-uncuyo-down() {
#     echo "🔽 Bajando desde OneDrive..."
#
#     if [[ "$*" == *"--dry-run"* ]] || [[ "$*" == *"-n"* ]]; then
#         rclone sync UNCuyo:lcc ~/uncuyo/ \
#             --track-renames --create-empty-src-dirs --fast-list -v --progress "$@"
#         echo "🔍 Dry-run - No se registró"
#     else
#         if rclone sync UNCuyo:lcc ~/uncuyo/ \
#             --track-renames --create-empty-src-dirs --fast-list -v --progress "$@"; then
#
#             log-local "DOWN"
#             echo "✅ Bajada completada y registrada localmente"
#         else
#             echo "❌ Error en la bajada"
#         fi
#     fi
# }
#
# # ====================== ALIASES ======================
#
# # Muestra SOLO la última subida a la nube
# alias who-last-sync='echo "=== ÚLTIMA SUBIDA A LA NUBE ===" && \
#     if [ -f "$SYNCED_LOG" ]; then
#         tail -n 1 "$SYNCED_LOG"
#     else
#         echo "No hay historial sincronizado aún"
#     fi'
#
# # Historial completo de subidas (sincronizado)
# alias sync-history='echo "=== HISTORIAL DE SUBIDAS EN LA NUBE ===" && \
#     if [ -f "$SYNCED_LOG" ]; then
#         cat "$SYNCED_LOG" | tail -n 30
#     else
#         echo "No hay historial sincronizado aún"
#     fi'
#
# # Historial local completo
# alias sync-history-local='echo "=== HISTORIAL LOCAL COMPLETO ===" && \
#     if [ -f "$LOCAL_LOG" ]; then
#         cat "$LOCAL_LOG" | tail -n 30
#     else
#         echo "No hay historial local aún"
#     fi'
#
# # Última actividad en esta máquina
# alias who-last-local='echo "=== ÚLTIMA ACTIVIDAD EN ESTA MÁQUINA ===" && \
#     if [ -f "$LOCAL_LOG" ]; then
#         tail -n 1 "$LOCAL_LOG"
#     else
#         echo "No hay historial local aún"
#     fi'


# sync-uncuyo-up() {
#     echo "Iniciando sincronización hacia OneDrive..."
#     # Añadimos --stats-one-line para un resumen limpio al final
#     rclone sync ~/uncuyo/ UNCuyo:lcc --track-renames --create-empty-src-dirs --fast-list -v --progress $@
#     # rclone sync ~/uncuyo/ UNCuyo:lcc --track-renames -v --progress --stats-one-line $@
#     #
#     # if [ $? -eq 0 ]; then
#     #     echo "✅ Sincronización de subida completada con éxito."
#     # else
#     #     echo "❌ Hubo errores durante la sincronización. Revisá el output de rclone arriba."
#     # fi
# }
#
# # Sincronizar DESDE la nube HACIA la laptop (Download)
# sync-uncuyo-down() {
#     echo "Sincronizando desde OneDrive a local (Bajada)..."
#     rclone sync UNCuyo:lcc ~/uncuyo/ --track-renames --create-empty-src-dirs --fast-list -v --progress $@
#     # rclone sync UNCuyo:lcc ~/uncuyo/ --track-renames -v --progress --stats-one-line $@
#     #
#     # if [ $? -eq 0 ]; then
#     #     echo "✅ Sincronización de bajada completada con éxito."
#     # else
#     #     echo "❌ Hubo errores. Es posible que falten archivos por descargar."
#     # fi
# }

# # Alias para un simulacro rápido
# alias check-uncuyo-up='sync-uncuyo-up --dry-run'
#
# # Alias para simular la bajada
# alias check-uncuyo-down='sync-uncuyo-down --dry-run'
#
# #Alias para checkear qué falta subir (me parece que no me sirve)
# alias check-falta-subir='rclone check ~/uncuyo/ UNCuyo:lcc --one-way'
#
# #Alias para checkear qué falta bajar (me parece que no me sirve)
# alias check-falta-bajar='rclone check UNCuyo:lcc ~/uncuyo/ --one-way'
#
# # Alias para Uso diario / habitual
# alias status-uncuyo='echo "=== STATUS UNCuyo ===" && rclone check ~/uncuyo/ UNCuyo:lcc --track-renames --size-only --fast-list --retries 1 -q && echo "✅ Todo sincronizado" || echo "⚠️  Hay diferencias (usa verify-uncuyo)"'
#
# # Alias para Diagnóstico completo
# alias verify-uncuyo='echo "=== VERIFY UNCuyo ===" && rclone check ~/uncuyo/ UNCuyo:lcc --track-renames --size-only --fast-list -v && echo "✅ Todo sincronizado" || echo "⚠️  Hay diferencias"'

# ==================== ALIASES GENERALES ====================
alias geogebra='_JAVA_AWT_WM_NONREPARENTING=1 geogebra'
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

# ==================== ALIASES DE UTILERÍA (UNCuyo Sync) ====================
alias sync-uncuyo-up='sync-uncuyo up'
alias sync-uncuyo-down='sync-uncuyo down'
alias check-uncuyo-up='sync-uncuyo up --dry-run'
alias check-uncuyo-down='sync-uncuyo down --dry-run'

alias who-last-sync='sync-uncuyo last'
alias who-last-local='sync-uncuyo last-local'
alias sync-history='sync-uncuyo history'
alias sync-history-local='sync-uncuyo history-local'

alias check-falta-subir='rclone check ~/uncuyo/ UNCuyo:lcc --one-way'
alias check-falta-bajar='rclone check UNCuyo:lcc ~/uncuyo/ --one-way'
alias status-uncuyo='echo "=== STATUS UNCuyo ===" && rclone check ~/uncuyo/ UNCuyo:lcc --track-renames --size-only --fast-list --retries 1 -q && echo "✅ Todo sincronizado" || echo "⚠️  Hay diferencias (usa verify-uncuyo)"'
alias verify-uncuyo='echo "=== VERIFY UNCuyo ===" && rclone check ~/uncuyo/ UNCuyo:lcc --track-renames --size-only --fast-list -v && echo "✅ Todo sincronizado" || echo "⚠️  Hay diferencias"'

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

# # ==================== StarDict ====================
# enes() {
#     [[ $# -eq 0 ]] && { echo "Uso: def <palabra>"; return 1 }
#
#     local palabra="$1"
#     local columnas=$(tput cols)
#
#     {
#         # --- Dictionary 1: English-English (Con formato color y limpieza HTML) ---
#         echo -e "\e[1;33m--- Dictionary (ES-ES) ---\e[0m"
#         sdcv -n -c --utf8-output -u "Wiktionary en-en" "$palabra" | \
#             html2text -b "$columnas" --ignore-links --ignore-images --unicode-snob | \
#             sed "s/-->/\x1b[1;36m&/g; s/$/\x1b[0m/"
#
#         echo -e "\n" # Espaciador
#
#         # --- Diccionario 2: Longman (Salida cruda o personalizada) ---
#         echo -e "\e[1;32m--- Pronunciación (Longman) ---\e[0m"
#         # Aquí puedes añadir un sed o un awk específico para Longman si lo deseas
#         sdcv -n -c -u "Longman Pronunciation Dictionary 3rd Ed. (En-En)" "$palabra"
#
#         # --- Diccionario 3: (Opcional) Ejemplo de un tercer formato ---
#          # echo -e "\n\e[1;35m--- Definición Rápida ---\e[0m"
#          # sdcv -n -u "English-español FreeDict+WikDict dictionary (en-es)" "$palabra" | head -n 10
#
#         # --- Diccionario 4: English-Español (Con formato color y limpieza HTML) ---
#         echo -e "\e[1;33m--- Translate (EN-ES) ---\e[0m"
#         sdcv -n -c --utf8-output -u "English-español FreeDict+WikDict dictionary (en-es)" "$palabra" | \
#             html2text -b "$columnas" --ignore-links --ignore-images --unicode-snob | \
#             sed "s/-->/\x1b[1;36m&/g; s/$/\x1b[0m/"
#
#     } | less -F -X -R
# }
#
# esen() {
#     [[ $# -eq 0 ]] && { echo "Uso: def <palabra>"; return 1 }
#
#     local palabra="$1"
#     local columnas=$(tput cols)
#
#     {
#         # --- Dictionary 1: English-English (Con formato color y limpieza HTML) ---
#         echo -e "\e[1;33m--- Traducción (EN-ES) ---\e[0m"
#         sdcv -n -c --utf8-output -u "Spanish-English FreeDict Dictionary (es-en)" "$palabra" | \
#             html2text -b "$columnas" --ignore-links --ignore-images --unicode-snob | \
#             sed "s/-->/\x1b[1;36m&/g; s/$/\x1b[0m/"
#
#         echo -e "\n" # Espaciador
#
#         # --- Diccionario 2: Longman (Salida cruda o personalizada) ---
#         #echo -e "\e[1;32m--- Pronunciación (Longman) ---\e[0m"
#         # Aquí puedes añadir un sed o un awk específico para Longman si lo deseas
#         # sdcv -n -c -u "Wiktionary es-en" "$palabra"
#
#         # --- Diccionario 3: (Opcional) Ejemplo de un tercer formato ---
#          # echo -e "\n\e[1;35m--- Definición Rápida ---\e[0m"
#          # sdcv -n -u "English-español FreeDict+WikDict dictionary (en-es)" "$palabra" | head -n 10
#
#         # --- Diccionario 4: English-Español (Con formato color y limpieza HTML) ---
#          echo -e "\e[1;33m--- Traducción (EN-ES) ---\e[0m"
#          sdcv -n -c --utf8-output -u "Wiktionary es-en" "$palabra" | \
#              html2text -b "$columnas" --ignore-links --ignore-images --unicode-snob | \
#              sed "s/-->/\x1b[1;36m&/g; s/$/\x1b[0m/"
#
#     } | less -F -X -R
# }
#



# ==================== CONFIGURACIÓN NNN ====================
export NNN_TERMINAL="foot"          # Fuerza que use foot para cualquier cosa que necesite un terminal nuevo
export NNN_FIFO="/tmp/nnn.fifo"      # necesario para previews
export NNN_PLUG='p:preview-tui;z:fzcd;f:fzfopen;j:autojump;v:imgview;d:dragdrop;t:treeview;'
export NNN_BMS='d:~/Downloads;D:~/Documentos;c:~/.config;p:~/Proyectos;l:~/uncuyo/linux;u:~/uncuyo/cursos'  # bookmarks (presiona b para ver)
# Colores bonitos + icons (con Nerd Font)
export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'
#export NNN_FCOLORS='c1e2272e006033f7c6d6ab00'  # ajustado
export NNN_ICONLOOKUP=1  # si compilaste nnn con icons, o usa plugin
#alias n="nnn -de"  # -d: no-cd on quit (útil a veces), -e: text en $EDITOR
# export NNN_USE_EDITOR=1  # opcional, pero ponlo en 1 si quieres forzar CLI para texto
# Usa rifle como opener en nnn (recomendado, reutiliza tu config de ranger). Asegúrate de tener rifle instalado (viene con ranger, así que ya lo tienes).
# Corrige NNN_OPTS: combina las flags que sí quieres (sin 'r', ya que no sirve)
export NNN_OPTS="ac"   # 'a' = auto-cd al salir, 'c' = CLI-only opener (útil si quieres evitar algunos GUI fallbacks)
# ¡Esto es lo que activa rifle como opener principal!
export NNN_OPENER="rifle"
# Opcional pero recomendado: reutiliza el rifle.conf de ranger
export NNN_RIFLE_CONF="$HOME/.config/ranger/rifle.conf"
#alias n="nnn -de"  # descomenta si quieres alias con -d -e
#--------------------------------
#
# Alias para abrir nvim en el directorio de configuracion de prueba que he elegido
#alias nvim-test='XDG_CONFIG_HOME=~ NVIM_APPNAME=test-nvim XDG_DATA_HOME=~/test-nvim/data nvim'
# alias nvim-test='NVIM_APPNAME=nvim-test nvim'

# ==================== FUNCIONES INTERACTIVAS RÁPIDAS ====================
# Captura un color y muestra su codigo hexadecimal en la terminal
pickcolor() {
    local color=$(grim -g "$(slurp -p)" -t ppm - | magick - -format '%[pixel:p{0,0}]\n' txt:- | tail -n 1 | cut -d ' ' -f 4)
    echo "$color"
    echo "$color" | wl-copy # Esto lo copia al portapapeles automáticamente
}

