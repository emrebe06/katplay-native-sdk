# Verify a KatPlay release

KatPlay Alpha 1 release assets are protected by two checks:

1. `SHA256SUMS.txt` lists the expected SHA-256 digest of each archive.
2. `SHA256SUMS.txt.sig` is an Ed25519 SSH signature over that exact manifest.

Release signing-key fingerprint:

```text
SHA256:izX4xT8KNnsRqXiQ9j18CwlW04dUGsprDpoukR7vQeU
```

The public key is committed at `keys/katplay-release-ed25519.pub`. Confirm its
fingerprint:

```powershell
ssh-keygen -lf keys/katplay-release-ed25519.pub -E sha256
```

```bash
ssh-keygen -lf keys/katplay-release-ed25519.pub -E sha256
```

## Verify the signed manifest

Run from the directory containing `SHA256SUMS.txt` and
`SHA256SUMS.txt.sig`. Point `-f` at the repository's `keys/allowed_signers`
file:

```bash
ssh-keygen -Y verify \
  -f ../keys/allowed_signers \
  -I katplay-release \
  -n katplay-release \
  -s SHA256SUMS.txt.sig < SHA256SUMS.txt
```

Expected output includes:

```text
Good "katplay-release" signature for katplay-release
```

## Verify archive hashes

PowerShell:

```powershell
Get-FileHash -Algorithm SHA256 .\KatPlay-0.1.0-alpha.1-windows-x86_64.zip
```

Linux:

```bash
sha256sum -c SHA256SUMS.txt
```

The signature proves that the manifest was signed by the holder of the KatPlay
release private key. The hash check then proves that an archive matches the
signed manifest.

