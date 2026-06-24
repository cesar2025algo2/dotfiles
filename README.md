# ⚙️ Dotfiles

Mis archivos de configuración personales para un entorno minimalista y eficiente en Arch Linux. Gestionados limpiamente usando **GNU Stow**.

---

## 🛠️ Estructura del Repositorio

El repositorio está organizado en paquetes independientes listos para ser enlazados simbólicamente a `$HOME`:

*   **Entorno Gráfico / WM:** `i3`, `sway`, `waybar`, `i3status`
*   **Terminales:** `alacritty`, `foot`, `kitty`, `tmux`
*   **Editores:** `nvim` (Neovim moderno con Lazy.nvim), `vim_exo`
*   **Productividad & Herramientas:** `zathura` (PDFs), `qutebrowser` (Navegador ligero), `bin` (Scripts de mantenimiento, sincronización y utilidades)
*   **Shell:** `zsh_exo`

---

## 🚀 Instalación y Replicación del Entorno

### 1. Sistema Base y Clonación
Primero, instalá los paquetes esenciales para clonar y gestionar el repositorio:

```bash
sudo pacman -S git stow --needed
```
