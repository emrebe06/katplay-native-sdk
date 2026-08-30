# Verify a KatPlay release

Signed KatPlay release assets are protected by two checks:

1. A versioned `SHA256SUMS-*.txt` file lists the expected SHA-256 digest of
   each archive.
2. The adjacent `.sig` file is an Ed25519 SSH signature over that exact
   manifest.

## Signing-key rotation

Alpha 1 was signed by the original release key:

```text
SHA256:izX4xT8KNnsRqXiQ9j18CwlW04dUGsprDpoukR7vQeU
```

That private key was lost and retired on 30 August 2026. Alpha 3 and later
releases use the replacement key:

```text
SHA256:KQRIInURMNolBohsw8n9aNTsduSSFokUbad8CAEboWY
```

The public keys are committed at `keys/katplay-release-ed25519.pub` and
`keys/katplay-release-ed25519-2026-08.pub`. The original public key remains in
`keys/allowed_signers` solely so historical signatures continue to verify.
Confirm the current key fingerprint:

```powershell
ssh-keygen -lf keys/katplay-release-ed25519-2026-08.pub -E sha256
```

```bash
ssh-keygen -lf keys/katplay-release-ed25519-2026-08.pub -E sha256
```

## Verify the signed manifest

Run from the directory containing the manifest and its `.sig` file. Point
`-f` at the repository's `keys/allowed_signers` file. For Alpha 3:

```bash
ssh-keygen -Y verify \
  -f ../keys/allowed_signers \
  -I katplay-release \
  -n katplay-release \
  -s SHA256SUMS-0.3.0-alpha.1.txt.sig < SHA256SUMS-0.3.0-alpha.1.txt
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
