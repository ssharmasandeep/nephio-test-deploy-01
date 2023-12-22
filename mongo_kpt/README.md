# mongo_kpt

## Description
sample description

## Usage

### Fetch the package
`kpt pkg get REPO_URI[.git]/PKG_PATH[@VERSION] mongo_kpt`
Details: https://kpt.dev/reference/cli/pkg/get/

### View package content
`kpt pkg tree mongo_kpt`
Details: https://kpt.dev/reference/cli/pkg/tree/

### Apply the package
```
kpt live init mongo_kpt
kpt live apply mongo_kpt --reconcile-timeout=2m --output=table
```
Details: https://kpt.dev/reference/cli/live/
