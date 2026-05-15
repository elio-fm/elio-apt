#!/bin/sh
set -eu

repo_url="${ELIO_APT_REPO_URL:-https://elio-fm.github.io/elio-apt}"
keyring="/etc/apt/keyrings/elio-archive-keyring.gpg"
source_list="/etc/apt/sources.list.d/elio.list"

if [ "$(id -u)" -ne 0 ]; then
  echo "Run this installer as root, for example: curl -fsSL ${repo_url}/install.sh | sudo sh" >&2
  exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
  echo "apt-get was not found. This installer is only for Debian-based systems." >&2
  exit 1
fi

download() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$1" -o "$2"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$2" "$1"
  else
    echo "curl or wget is required to configure the elio apt repository." >&2
    exit 1
  fi
}

tmp_key="$(mktemp)"
trap 'rm -f "$tmp_key"' EXIT

install -d -m 0755 /etc/apt/keyrings
download "${repo_url}/elio-archive-keyring.gpg" "$tmp_key"
install -m 0644 "$tmp_key" "$keyring"

printf '%s\n' "deb [arch=amd64 signed-by=${keyring}] ${repo_url} stable main" > "$source_list"
apt-get update

echo "elio apt repository configured. Install elio with: sudo apt install elio"
