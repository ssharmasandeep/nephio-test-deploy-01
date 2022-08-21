# roles

## Description
sample description

## Usage

### Fetch the package
`kpt pkg get REPO_URI[.git]/PKG_PATH[@VERSION] roles`
Details: https://kpt.dev/reference/cli/pkg/get/

### View package content
`kpt pkg tree roles`
Details: https://kpt.dev/reference/cli/pkg/tree/

### Apply the package
```
kpt live init roles
kpt live apply roles --reconcile-timeout=2m --output=table
```
Details: https://kpt.dev/reference/cli/live/
