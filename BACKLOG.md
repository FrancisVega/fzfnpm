# Backlog — fzfnpm

Roadmap de mejoras para profesionalizar la herramienta. Ordenado por prioridad sugerida.
Las casillas marcadas (`[x]`) están hechas; las vacías (`[ ]`) están pendientes.

---

## ✅ P1 — Instalación nativa (salir de Homebrew) — COMPLETADO

**Objetivo:** sustituir el tap de Homebrew por un instalador de una línea, sin mantenimiento de fórmulas.

```bash
curl -fsSL https://raw.githubusercontent.com/FrancisVega/fzfnpm/main/install.sh | bash
```

**Motivo:** mantener el tap (`FrancisVega/taps`) es un engorro y añade fricción a cada release.

### Tareas
- [x] Crear `install.sh` en la raíz del repo:
  - [x] Directorio de instalación configurable: `BIN_DIR="${FZFNPM_INSTALL_DIR:-$HOME/.local/bin}"`.
  - [x] `chmod +x` y colocar en `BIN_DIR`.
  - [x] Verificar dependencias (`fzf`, `jq`) y dar instrucciones claras si faltan (brew/apt/dnf/pacman).
  - [x] Avisar si `BIN_DIR` no está en el `PATH` y cómo añadirlo.
  - [x] Salir con código ≠ 0 ante cualquier fallo (`set -euo pipefail` + sanity check de la descarga).
  - [x] Instala la **última release** por defecto (resuelta vía API de GitHub); `FZFNPM_VERSION` fija una versión concreta o usa `main`.
- [x] Actualizar `README.md`: instalación curl-first; Homebrew eliminado por completo; documentado `--uninstall` y cómo fijar versión.
- [x] Soporte de desinstalación: `fzfnpm --uninstall` (borra el binario y limpia la caché).
- [x] Publicar **GitHub Releases con tags**: release `v0.10.0` (el instalador la resuelve como «latest»).
- [x] Push a `main` hecho.
- [ ] (Opcional) Soporte de auto-update: `fzfnpm --update` que re-ejecute el instalador.

> ✅ Portabilidad (`md5`) ya resuelta en P2, así que el `curl | bash` ya no se rompe en Linux.

---

## 🐛 P2 — Robustez / portabilidad

- [x] **Portabilidad del hash (bug):** ~~`md5 -q` solo existe en macOS~~. Resuelto con `hash_cwd` (usa `md5sum`/`md5`/`cksum` según disponibilidad).
- [ ] **Validar dependencias en runtime:** comprobar que `fzf` y `jq` están instalados; si no, mensaje claro en vez de error críptico.
- [ ] **`set -euo pipefail`** y manejo de errores consistente.
- [ ] **Simplificar el parsing de scripts:** sustituir `jq | sed 's/"//g' | grep -E '^\w'` por `jq -r '.scripts | keys[]'` (más robusto; el `grep` actual puede descartar scripts válidos).
- [ ] **Caché en ruta de usuario:** mover de `/tmp/...` a `${XDG_CACHE_HOME:-$HOME/.cache}/fzfnpm/` (evita choques de permisos entre usuarios).
- [ ] **Versión única:** dejar de hardcodear `0.9.0` en 2 sitios; fuente de verdad única (variable o fichero `VERSION`).

---

## ✨ P3 — UX / features

- [x] **Preview en fzf:** mostrar el comando real de cada script (`--preview`) leyendo su valor de `package.json`.
- [x] **`--help` y `--version` largos** además de `-h`/`-v`; help que liste todas las opciones.
- [x] **Aviso si no hay scripts:** si `.scripts` está vacío o no existe, mensaje claro en vez de abrir `fzf` vacío.
- [ ] (Opcional) Pasar argumentos extra al script (`fzfnpm -- --flag`).
- [ ] (Opcional) Búsqueda de `package.json` hacia arriba en el árbol de directorios (monorepos).

---

## 🏗️ P4 — Infraestructura del proyecto

- [ ] **Tests** con [bats](https://github.com/bats-core/bats-core) (detección de PM, parsing de scripts, caché).
- [ ] **CI** con GitHub Actions: lint con `shellcheck` + tests en macOS y Linux.
- [ ] **`LICENSE`** (p. ej. MIT).
- [ ] **`CHANGELOG.md`** siguiendo Keep a Changelog.
- [ ] (Opcional) `shfmt` para formato consistente.
