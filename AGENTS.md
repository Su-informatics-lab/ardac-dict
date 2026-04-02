# Agent Instructions for ARDaC Data Dictionary

## Build, Test, and Lint Commands

- **Validate Dictionary:** Run validation using the provided Docker image. This checks the schemas and generates a `schema.json` file.
  ```bash
  docker run --rm -v $(pwd):/mnt/host quay.io/rds/dictutils
  ```
  Note: On Windows PowerShell, use `${PWD}` instead of `$(pwd)`.

- **Versioning for Validation:** To ensure the generated `schema.json` has the correct version, create a git tag before running validation:
  ```bash
  git tag <version-tag>
  # Then run validation
  ```

- **CI/CD:** Validation is automated in GitHub Actions via `.github/workflows/pr-validation.yml` using the same Docker command.

## High-level Architecture

- **Format:** This repository defines a data dictionary for the Gen3 data commons platform using the [dictionaryutils](https://github.com/uc-cdis/dictionaryutils) library.
- **Schemas:** Data nodes are defined in YAML files located in `gdcdictionary/schemas/`.
- **Package:** The `gdcdictionary` Python package (defined in `setup.py`) exposes a `DataDictionary` instance initialized with these schemas.
- **Output:** The primary build artifact is `schema.json`, which is deployed to the Gen3 environment.

## Key Conventions

- **Workflow:** This project follows Gitflow:
  - Feature branches (`feat/*`) are created from and merged back into `develop`.
  - Release branches (`release/*`) are used to prepare releases from `develop` to `main`.
  - Hotfixes (`hotfix/*`) are for critical fixes on `main`.
- **Root Execution:** Always run the validation command from the repository root to ensure all schema files are found correctly.
- **Custom Keywords:** The schemas use custom keywords like `systemAlias` (database storage name), `systemProperties` (immutable by submitter), and `parentType` (relationship target).
- **Branch Naming:** Use descriptive branch names like `feat/new-file-type`.
