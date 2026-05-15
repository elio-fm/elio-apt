# elio apt repository

Official apt repository for [elio](https://github.com/elio-fm/elio), a batteries-included terminal file manager.

## Install

Configure the repository, then install elio:

```bash
curl -fsSL https://elio-fm.github.io/elio-apt/install.sh | sudo sh
sudo apt install elio
```

This repository currently publishes `amd64` packages. It uses a repository-specific keyring and `signed-by`, so the elio signing key is scoped to this repository only.

## Manual Setup

Use these commands instead of the installer script if you prefer to see each step:

```bash
sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://elio-fm.github.io/elio-apt/elio-archive-keyring.gpg \
  | sudo tee /etc/apt/keyrings/elio-archive-keyring.gpg >/dev/null

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/elio-archive-keyring.gpg] https://elio-fm.github.io/elio-apt stable main" \
  | sudo tee /etc/apt/sources.list.d/elio.list

sudo apt update
sudo apt install elio
```

## Maintainer Notes

The `main` branch contains the apt repository config and publish workflow. Generated repository files are published to the `gh-pages` branch.

Required repository secrets:

- `APT_SIGNING_KEY`: armored private GPG key used to sign apt metadata
- `APT_SIGNING_PASSPHRASE`: passphrase for the signing key

The publish workflow can be run manually with a release tag such as `v1.5.1`. It downloads `elio_amd64.deb` from the matching elio release, updates the apt repository with `reprepro`, signs the metadata, and publishes the result to GitHub Pages.

Create a dedicated signing key with a long but finite expiry, then keep an offline backup:

```bash
gpg --full-generate-key
gpg --export-secret-keys --armor <KEY_ID> > elio-apt-private.asc
gpg --export --armor <KEY_ID> > elio-apt-public.asc
```

Recommended key properties:

- dedicated only to the elio apt repository
- 4096-bit RSA
- 5-year expiry
- strong passphrase

Set a calendar reminder one year before expiry so the key can be rotated before users see apt errors.
