# GitHub Action to run AWS Cloudformation Guard

This Action for [CloudFormation Guard](https://github.com/aws-cloudformation/cloudformation-guard) verifies that cloudfomation templates meet a built-in pre-defined set of rules.


## Inputs

### `cfn_subdirectory`

**Required** The directory where cloudformation templates are stored. Default `"cdk.out"`.

## Outputs

None

## Example usage

```yaml
name: Check CloudFormation Templates with CFN Guard

on: [push]

jobs:

  check-cfn-templates:

    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v2

    - name: Cloudformation Guard Checks
      uses: maskerade/cfn-guard-action@master
      with: 
        cfn_subdirectory: 'cdk.out'
```