# Security policy

## Supported version

KatPlay `0.1.0-alpha.1` is the only currently supported public SDK version.
Because this is Alpha software, support is best-effort and no security SLA is
offered.

## Reporting a vulnerability

Please report suspected vulnerabilities privately to `emrebe06@gmail.com`
with the subject `KatPlay Security Report`.

Include, when possible:

- affected KatPlay version, platform and architecture;
- the SHA-256 hash of the runtime tested;
- a minimal reproduction and expected/actual behavior;
- crash logs or stack traces with personal data removed; and
- whether a specially crafted audio file is required.

Do not attach copyrighted audio that you are not authorized to share. A small
synthetic reproducer is preferred. Do not open a public GitHub issue containing
exploit details before a coordinated fix or disclosure decision.

## In-scope examples

- memory corruption or code execution caused by a crafted WAV, FLAC or MP3;
- out-of-bounds reads/writes, integer overflows or use-after-free behavior;
- unsafe path handling in the public load interface;
- denial of service that is reliably triggered by a small valid or malformed
  input; and
- bypass of a published integrity or future signed-license check.

## Research expectations

Perform testing only on systems and files you own or are authorized to test.
Do not access other people's data, disrupt third-party services, deploy
malware, or use a finding to demand payment. KatPlay does not currently operate
a bug bounty program. Good-faith reporters will be credited if they request it
and coordinated disclosure is safe.

## Release integrity

Release assets are listed in `release/SHA256SUMS.txt`. The manifest is signed
with the KatPlay Ed25519 release key. Verification instructions and the public
key are under `docs/VERIFY_RELEASE.md` and `keys/`.

Never trust a signing key delivered only beside a suspicious binary. Compare
the public-key fingerprint against the value published in the official KatPlay
repository and release notes.

