# Contributing

Contributions that improve this Terraform module are welcome. Keep changes focused, documented, and validated.

## Prerequisites

- Terraform version declared in `.terraform-version`.
- Docker for the terraform-docs pre-commit hook.
- Python with `pre-commit` installed.

## Local validation

```shell
tfswitch
pre-commit run --all-files
```

Do not manually edit content between Terraform Docs markers in `README.md`.

## Pull requests and releases

Use a Conventional Commit-compatible title. Semantic Release runs after merge to `main`, creates the tag and GitHub Release, and updates `CHANGELOG.md`.
