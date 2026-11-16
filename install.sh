#!/usr/bin/env bash
# Instala as skills da equipe (frontend-security, frontend-development) no Codex e/ou Claude Code.
#
# Uso (de dentro de um clone):   ./install.sh [--agent all|codex|claude] [--target DIR] [skill ...]
# Uso sem clone: ./install.sh --repo <url-git>  (padrão: o repositório da equipe)
set -euo pipefail

DEFAULT_REPO="git@github.com:fiea-observatorio/skills-observatorio.git"
REPO="${TEAM_SKILLS_REPO:-}"
AGENT="all"
TARGET=""
SKILLS=()

while [ $# -gt 0 ]; do
  case "$1" in
    --agent)  AGENT="$2"; shift 2 ;;
    --target) TARGET="$2"; shift 2 ;;
    --repo)   REPO="$2"; shift 2 ;;
    -h|--help) sed -n '2,5p' "$0" 2>/dev/null || true; exit 0 ;;
    *) SKILLS+=("$1"); shift ;;
  esac
done

case "$AGENT" in all|codex|claude) ;; *) echo "--agent deve ser all, codex ou claude" >&2; exit 1 ;; esac

# 1. Origem: o próprio clone ou um clone temporário
SCRIPT_DIR=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi
TMP=""
cleanup() { if [ -n "$TMP" ]; then rm -rf "$TMP"; fi; }
trap cleanup EXIT

if [ -n "$SCRIPT_DIR" ] && [ -d "$SCRIPT_DIR/skills" ]; then
  SRC="$SCRIPT_DIR/skills"
else
  REPO="${REPO:-$DEFAULT_REPO}"
  command -v git >/dev/null || { echo "git não encontrado." >&2; exit 1; }
  TMP="$(mktemp -d)"
  echo "Baixando $REPO ..."
  git clone --depth 1 --quiet "$REPO" "$TMP/repo"
  SRC="$TMP/repo/skills"
fi

[ -d "$SRC" ] || { echo "Pasta skills/ não encontrada no repositório." >&2; exit 1; }
if [ ${#SKILLS[@]} -eq 0 ]; then
  for d in "$SRC"/*/; do [ -f "$d/SKILL.md" ] && SKILLS+=("$(basename "$d")"); done
  [ ${#SKILLS[@]} -gt 0 ] || { echo "Nenhuma skill (SKILL.md) encontrada em $SRC." >&2; exit 1; }
fi
for s in "${SKILLS[@]}"; do
  [ -f "$SRC/$s/SKILL.md" ] || { echo "Skill inexistente: $s" >&2; exit 1; }
done

# 2. Destinos
TARGETS=()
if [ -n "$TARGET" ]; then
  TARGETS=("$TARGET")
elif [ "$AGENT" != "all" ]; then
  TARGETS=("$HOME/.$AGENT/skills")
else
  for a in codex claude; do [ -d "$HOME/.$a" ] && TARGETS+=("$HOME/.$a/skills"); done
  [ ${#TARGETS[@]} -eq 0 ] && TARGETS=("$HOME/.codex/skills")
fi

# 3. Copia (substitui versão anterior)
for t in "${TARGETS[@]}"; do
  mkdir -p "$t"
  for s in "${SKILLS[@]}"; do
    rm -rf "${t:?}/$s"
    cp -R "$SRC/$s" "$t/$s"
    echo "  ok  $s -> $t/$s"
  done
done
echo "Pronto. Reinicie o Codex/Claude Code para carregar as skills."
