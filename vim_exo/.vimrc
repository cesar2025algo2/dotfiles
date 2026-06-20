" =======================================
" --- CONFIGURACIÓN BÁSICA ---
" =======================================

set nocompatible         " Deshabilita el modo de compatibilidad para usar las características de Vim
syntax on                " Habilita el resaltado de sintaxis (colores)
filetype plugin indent on
set background=dark          " Usa la variante oscura
set cursorline
set number               " Muestra los números de línea absolutos
set relativenumber       " Muestra los números de línea relativos (útil para moverse: 5k para 5 líneas arriba)

set mouse=a              " Habilita el uso del ratón (útil al principio)

set clipboard=unnamedplus " Usa el registro del sistema como predeterminado para el pegado

"highlight CursorLine cterm=bold ctermbg=236 gui=bold guibg=#4E535C

" Configura la indentación
set tabstop=4            " Un tabulador equivale a 4 espacios
set shiftwidth=4         " Cuántos espacios se usa para la auto-indentación
set expandtab            " Convierte las tabulaciones a espacios

"set ruler                " Muestra la posición actual (línea, columna)
"set showcmd              " Muestra comandos incompletos en la parte inferior
"set undofile             " Permite deshacer ilimitado y a través de sesiones
set showmatch            " Muestra paréntesis coincidentes brevemente
"set laststatus=2         " Siempre muestra la línea de estado

" --- Búsqueda y Escritura ---
set hlsearch             " Resalta todas las coincidencias de búsqueda
set smartcase            " Búsqueda inteligente (ignora mayúsculas si solo usas minúsculas)
set incsearch            " Muestra las coincidencias a medida que escribes
set wrap                 " Envolver líneas largas (evita desplazamiento horizontal)

" =======================================
" --- GESTOR DE PLUGINS (VIM-PLUG) ---
" =======================================
" Inicio de la sección de plugins
call plug#begin('~/.vim/plugged')

" Plugins:
Plug 'preservim/nerdtree'           " Explorador de archivos (árbol de directorios)
Plug 'morhetz/gruvbox'          " El tema Gruvbox
Plug 'vim-airline/vim-airline'      " Barra de estado atractiva y útil
Plug 'vim-airline/vim-airline-themes' " Temas para la barra
Plug 'sheerun/vim-polyglot'         " Syntax highlighting para muchos lenguajes, incluyendo Python avanzado
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'         " Comentar/descomentar líneas fácilmente (con 'gc')
Plug 'preservim/vim-markdown'       " Importante para el plegado de Markdown
"Plug 'shinchu/lightline-gruvbox.vim'
Plug 'jiangmiao/auto-pairs'
"Plug 'alvan/vim-closetag'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'    " requerido para vim-markdown
"Plug 'plasticboy/vim-markdown'

" Fin de la sección de plugins
call plug#end()

" =======================================
" --- CONFIGURACIÓN DE VIM-MARKDOWN ---
" =======================================

" Opcional: no plegar listas anidadas (solo encabezados)
"let g:vim_markdown_folding_style_pythonic = 1 

" =======================================
" --- ATAJOS DE PLEGADO PARA MARKDOWN ---
" =======================================

" Plegar/desplegar sección actual con espacio + a
nnoremap <leader>a za

" Cerrar todas las secciones excepto la actual
nnoremap <leader>z zMzv

" Guardar y restaurar estado de plegado
nnoremap <leader>s :mkview<CR>
nnoremap <leader>l :loadview<CR>

" Plegar/desplegar todo
nnoremap <leader>m zM  " cerrar todo
nnoremap <leader>r zR  " abrir todo

" Navegar entre pliegues
nnoremap <leader>j zj  " siguiente pliegue
nnoremap <leader>k zk  " anterior pliegue

" =======================================
" Configuración extra: Abrir NERDTree con Ctrl+n
nnoremap <C-n> :NERDTreeToggle<CR>
set termguicolors            " Crucial para Alacritty
colorscheme gruvbox          " Aplica el tema
" Configuración de Airline (la barra de abajo)
let g:airline_theme='gruvbox'
let g:airline#extensions#tabline#enabled = 1 " Muestra buffers abiertos arriba

" --- CONFIGURACIÓN DE AUTOCOMPLETADO (COC.NVIM) ---

" Usa <Tab> y <S-Tab> para navegar por las sugerencias
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" Usa <CR> (Enter) para confirmar la selección o saltar al siguiente placeholder
inoremap <silent><expr> <CR> (pumvisible() ? coc#_select_confirm() : "\<CR>")

" Configuración de la barra de estado de Coc
set statusline+=%M
set shortmess+=c

" Siempre muéstrame la documentación en una ventana flotante
set signcolumn=yes
let g:coc_suggest_timeout = 500
"----------------------------------------------
" Encerrar bloque en bloques de código Markdown con un solo comando
vnoremap <leader>b <Esc>`>o```<Esc>`<O```<Esc>

"-----------------------------------------------
" Comando para ver Markdown con Pandoc + MathJax (muestra el texto restringido a la franja central en la pantalla del navegador)
command! Preview2 w | !pandoc % -s --mathjax -o /tmp/%:t:r.html && falkon /tmp/%:t:r.html &

command! Preview3 w | !pandoc % --mathjax -s -V mainfont="DejaVu Sans" -o /tmp/%:t:r.html && falkon /tmp/%:t:r.html &

" Comando para ver Markdown con Pandoc + MathJax usando estilo.css para que expandir el texto al ancho de la ventana, ya que Pandoc con Mathjax muestra el texto restringido a la franja central en la pantalla del navegador.
command! Preview1 w | !pandoc % --mathjax -s -c ~/.config/pandoc/estilo.css -o /tmp/%:t:r.html && falkon /tmp/%:t:r.html &
" Comando para ver markdown con Pandoc + tex live (off-line)
command! Preview4 w | !pandoc % -o /tmp/%:t:r.pdf && zathura /tmp/%:t:r.pdf &
" Comando para ver markdown con Pandoc + tex live (off-line) sin error por
" caracteres no reconocidos
command! Preview5 w | !pandoc % -o /tmp/%:t:r.pdf --pdf-engine=xelatex && zathura /tmp/%:t:r.pdf &

"atajo" (mapping) para no tener que escribir `:Preview` cada vez que quiera ver una vista previa. Presionas la tecla líder —usualmente la barra invertida \ o el espacio— seguida de la p y luego la p o la o segun el caso, se abrirá el navegador automáticamente).
" Preview sin CSS
nnoremap <leader>po :Preview2<CR>    
" Preview sin CSS otra font
nnoremap <leader>pi :Preview3<CR>    
" Preview con CSS completo
nnoremap <leader>pp :Preview1<CR> 
" Previews sin CSS hecho con pandoc y LaTex
nnoremap <leader>mp :Preview4<CR>
nnoremap <leader>mo :Preview5<CR>
"-----------------------------------------------
"cambiar latex por $ 
" Cambiar \[ ... \] por $$ ... $$
" Cambiar \( ... \) por $ ... $ (el que ya funcionó)
" Un solo comando que hace ambas sustituciones
command! AllToDollars %s/\\\[/$$/ge | %s/\\\]/$$/ge | %s/\\[(]\+/$/ge | %s/\\[)]\+/$/ge
command! ConfirmAllToDollars %s/\\\[/$$/gce | %s/\\\]/$$/gce | %s/\\[(]\+/$/gce | %s/\\[)]\+/$/gce

" Atajo 
nnoremap <leader>ad :AllToDollars<CR>
nnoremap <leader>af :ConfirmAllToDollars<CR>

