#!/usr/bin/env bash
set -e

REPO_DIR="$(realpath $(dirname "${BASH_SOURCE}")/..)"
cd "$REPO_DIR"

git pull origin main

function install() {
  # vs code
  unameOut="$(uname -s)"
  case $(uname | tr '[:upper:]' '[:lower:]') in
  linux*) vscode="$HOME/.config/Code/User/settings.json" ;;
  darwin*) vscode="$HOME/Library/Application Support/Code/User/settings.json" ;;
  msys*) vscode="%APPDATA%\Code\User\settings.json" ;;
  esac
  cp $REPO_DIR/vscode/settings.json "$vscode"
  echo "Copying the following files:\n"
  rsync --exclude ".git/" --exclude "./" \
    --exclude ".DS_Store" \
    --exclude ".gitignore" \
    --exclude "*.md" \
    --exclude "*.txt" \
    --exclude "*.bak" \
    --exclude ".bin" \
    --exclude "vscode" \
    --exclude "install.sh" \
    -avh --no-perms . $HOME --dry-run
  echo $vscode
  echo "Delete files from $REPO_DIR if undesired."
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/N) " -n 1
  echo ""

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # TODO: Deduplicate rsync command
    rsync --exclude ".git/" \
      --exclude ".DS_Store" \
      --exclude ".gitignore" \
      --exclude "*.md" \
      --exclude "*.txt" \
      --exclude "*.bak" \
      --exclude ".bin" \
      --exclude "vscode" \
      --exclude "install.sh" \
      -avh --no-perms . $HOME
  fi
}

install
