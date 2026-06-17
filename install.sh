#!/usr/bin/env bash
#
# fzfnpm installer
#
#   curl -fsSL https://raw.githubusercontent.com/FrancisVega/fzfnpmscript/main/install.sh | bash
#
# Environment variables:
#   FZFNPM_INSTALL_DIR   Target directory for the binary (default: ~/.local/bin)
#   FZFNPM_VERSION       Git ref to install (default: latest release; use 'main' for dev)
#
set -euo pipefail

REPO="FrancisVega/fzfnpmscript"
BIN_DIR="${FZFNPM_INSTALL_DIR:-$HOME/.local/bin}"
TARGET="${BIN_DIR}/fzfnpm"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*" >&2; }
err()  { printf '\033[1;31m[x]\033[0m %s\n' "$*" >&2; }

# --- pick a downloader -------------------------------------------------------
if command -v curl >/dev/null 2>&1; then
  fetch()    { curl -fsSL "$1"; }
  download() { curl -fsSL "$1" -o "$2"; }
elif command -v wget >/dev/null 2>&1; then
  fetch()    { wget -qO- "$1"; }
  download() { wget -qO "$2" "$1"; }
else
  err "Necesitas curl o wget para instalar fzfnpm."
  exit 1
fi

# --- resolve version ---------------------------------------------------------
# Por defecto instala la última release (tag) para que sea reproducible.
# Override con FZFNPM_VERSION=vX.Y.Z, o FZFNPM_VERSION=main para desarrollo.
if [ -n "${FZFNPM_VERSION:-}" ]; then
  VERSION="$FZFNPM_VERSION"
else
  VERSION="$(fetch "https://api.github.com/repos/${REPO}/releases/latest" 2>/dev/null \
    | grep '"tag_name":' | head -1 | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/' || true)"
  if [ -z "$VERSION" ]; then
    warn "No pude resolver la última release; usando 'main'."
    VERSION="main"
  fi
fi

SRC_URL="https://raw.githubusercontent.com/${REPO}/${VERSION}/bin/fzfnpm"

# --- download ----------------------------------------------------------------
info "Instalando fzfnpm (${VERSION}) en ${TARGET}"
mkdir -p "$BIN_DIR"

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

if ! download "$SRC_URL" "$tmp"; then
  err "No se pudo descargar $SRC_URL"
  exit 1
fi

# Sanity check: el fichero debe ser el script, no un 404 de GitHub.
if ! head -n1 "$tmp" | grep -q '^#!'; then
  err "La descarga no parece válida (¿la versión '${VERSION}' no existe?)."
  exit 1
fi

chmod 0755 "$tmp"
if ! mv "$tmp" "$TARGET" 2>/dev/null; then
  err "No se pudo escribir en $TARGET (¿permisos?)."
  err "Prueba con: FZFNPM_INSTALL_DIR=\$HOME/.local/bin bash"
  exit 1
fi

info "fzfnpm instalado en $TARGET ✅"

# --- post-install checks -----------------------------------------------------
missing=()
command -v fzf >/dev/null 2>&1 || missing+=("fzf")
command -v jq  >/dev/null 2>&1 || missing+=("jq")
if [ "${#missing[@]}" -gt 0 ]; then
  warn "Faltan dependencias: ${missing[*]}"
  warn "Instálalas con tu gestor de paquetes:"
  warn "  macOS:          brew install ${missing[*]}"
  warn "  Debian/Ubuntu:  sudo apt install ${missing[*]}"
  warn "  Fedora:         sudo dnf install ${missing[*]}"
  warn "  Arch:           sudo pacman -S ${missing[*]}"
fi

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *)
    warn "$BIN_DIR no está en tu PATH. Añádelo a tu shell rc, por ejemplo:"
    warn "  echo 'export PATH=\"$BIN_DIR:\$PATH\"' >> ~/.zshrc   # o ~/.bashrc"
    ;;
esac

info "Listo. Ejecuta 'fzfnpm' dentro de un proyecto con package.json."
