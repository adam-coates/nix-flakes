#!/usr/bin/env bash
# init-project - scaffold a new project from a nix-flakes template
#
# Usage:
#   init-project <template> <project-path>
#
# Examples:
#   init-project python ~/projects/my-app
#   init-project rust ~/code/my-crate
#   init-project --list

set -euo pipefail

FLAKES_REPO="https://github.com/adam-coates/nix-flakes.git"
FLAKES_DIR="${NIX_FLAKES_DIR:-${HOME}/nix-flakes}"

usage() {
  echo "Usage: init-project <template> <project-path>"
  echo ""
  echo "Options:"
  echo "  --list     List available templates"
  echo "  --update   Pull latest changes for all submodules"
  echo ""
  echo "Examples:"
  echo "  init-project python ~/projects/my-app"
  echo "  init-project rust ~/code/my-crate"
  exit 1
}

ensure_repo() {
  if [ ! -d "${FLAKES_DIR}/.git" ]; then
    echo "Cloning nix-flakes repo..."
    git clone --recurse-submodules "${FLAKES_REPO}" "${FLAKES_DIR}"
  fi
}

list_templates() {
  ensure_repo
  echo "Available templates:"
  echo ""
  for dir in "${FLAKES_DIR}"/*/; do
    [ -f "${dir}/flake.nix" ] || continue
    name=$(basename "${dir}")
    desc=$(grep -oP '(?<=description = ").*?(?=")' "${dir}/flake.nix" 2>/dev/null || echo "")
    echo "  ${name} — ${desc}"
  done
}

update_repo() {
  ensure_repo
  echo "Updating submodules..."
  git -C "${FLAKES_DIR}" pull
  git -C "${FLAKES_DIR}" submodule update --init --remote --recursive
  echo "Done."
}

case "${1:-}" in
  --list) list_templates; exit 0 ;;
  --update) update_repo; exit 0 ;;
  --help|-h|"") usage ;;
esac

TEMPLATE="$1"
PROJECT_PATH="$2"

ensure_repo

TEMPLATE_DIR="${FLAKES_DIR}/${TEMPLATE}"

if [ ! -f "${TEMPLATE_DIR}/flake.nix" ]; then
  echo "Error: template '${TEMPLATE}' not found" >&2
  echo ""
  list_templates
  exit 1
fi

mkdir -p "${PROJECT_PATH}"

if [ "$(ls -A "${PROJECT_PATH}" 2>/dev/null)" ]; then
  read -r -p "${PROJECT_PATH} is not empty. Copy template files anyway? [y/N] " ans
  [[ "${ans,,}" == "y" ]] || exit 1
fi

echo "Copying ${TEMPLATE} template to ${PROJECT_PATH}..."
cp -r "${TEMPLATE_DIR}/." "${PROJECT_PATH}/"
rm -rf "${PROJECT_PATH}/.git"

if [ -f "${PROJECT_PATH}/.envrc" ] && command -v direnv &>/dev/null; then
  direnv allow "${PROJECT_PATH}"
fi

echo ""
echo "Project created at ${PROJECT_PATH}"
echo ""
echo "Next steps:"
echo "  cd ${PROJECT_PATH}"
echo "  nix develop"
