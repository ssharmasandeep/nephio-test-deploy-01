# raemis_kpt

## Description
sample description

## Usage

### Fetch the package
`kpt pkg get REPO_URI[.git]/PKG_PATH[@VERSION] raemis_kpt`
Details: https://kpt.dev/reference/cli/pkg/get/

### View package content
`kpt pkg tree raemis_kpt`
Details: https://kpt.dev/reference/cli/pkg/tree/

### Apply the package
```
kpt live init raemis_kpt
kpt live apply raemis_kpt --reconcile-timeout=2m --output=table
```
Details: https://kpt.dev/reference/cli/live/
