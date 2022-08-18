# aws-eks

## Description
sample description

## Usage

### Fetch the package
`kpt pkg get REPO_URI[.git]/PKG_PATH[@VERSION] aws-eks`
Details: https://kpt.dev/reference/cli/pkg/get/

### View package content
`kpt pkg tree aws-eks`
Details: https://kpt.dev/reference/cli/pkg/tree/

### Apply the package
```
kpt live init aws-eks
kpt live apply aws-eks --reconcile-timeout=2m --output=table
```
Details: https://kpt.dev/reference/cli/live/
