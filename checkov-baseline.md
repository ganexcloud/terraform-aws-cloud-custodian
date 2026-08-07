# Checkov baseline

The `v0.1.0` migration baseline was scanned with Checkov 3.2.358 on 2026-08-07.
The following findings were present before modernization and remain excluded from
the validation gate until a separate least-privilege and S3 hardening change is
approved:

- `CKV2_AWS_14`, `CKV2_AWS_21`, `CKV2_AWS_62`
- `CKV_AWS_18`, `CKV_AWS_21`, `CKV_AWS_27`
- `CKV_AWS_108`, `CKV_AWS_109`, `CKV_AWS_110`, `CKV_AWS_111`
- `CKV_AWS_144`, `CKV_AWS_145`, `CKV_AWS_273`, `CKV_AWS_356`

The modernized branch introduces no Checkov finding outside this baseline set.
