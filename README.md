# elio APT Repository

Official APT repository for [elio](https://github.com/elio-fm/elio).

## Install

```bash
curl -fsSL https://elio-fm.github.io/elio-apt/install.sh | sudo sh
sudo apt install elio
```

The installer configures the elio APT source, installs the repository signing key, and updates package lists.

## Manual Setup

```bash
sudo install -d -m 0755 /etc/apt/keyrings

curl -fsSL https://elio-fm.github.io/elio-apt/elio-archive-keyring.gpg \
  | sudo tee /etc/apt/keyrings/elio-archive-keyring.gpg >/dev/null

arch="$(dpkg --print-architecture)"

echo "deb [arch=${arch} signed-by=/etc/apt/keyrings/elio-archive-keyring.gpg] https://elio-fm.github.io/elio-apt stable main" \
  | sudo tee /etc/apt/sources.list.d/elio.list

sudo apt update
sudo apt install elio
```

## Supported Packages

This repository publishes `amd64` and `arm64` packages for the `stable` APT distribution.
