## Version Compatibility
- 0.2+ -> terraform ~1.2 | aws provider <5
- 0.3+ -> terraform ~1.3 | aws provider <5
- 0.4+ -> terraform ~1.5 | aws provider ~5

## Additional Notes
- [Optional object type attributes][optional-object-type] were experimental in terraform 1.2; generally available as of 1.3.
- [terragrunt-null-issue]
- [template-function-issue]

## Changelog
### 0.4.0
- update constructs to require terraform ~1.5 with aws provider ~5.0
- remove `network/v1` module and construct; move `network/v2` to `network`
- add `params/lookup` module

### 0.4.1
- add `lambda/layer` module

### 0.4.2
- start construct and module for MongoDB Atlas Cluster backed by AWS

### 0.4.3
- start modules for Auth0 `resource-server` and `role`

[defaults-function]: https://www.terraform.io/language/functions/defaults
[optional-attributes-experiment]: https://www.terraform.io/language/expressions/type-constraints#experimental-optional-object-type-attributes
[terragrunt-null-issue]: https://github.com/gruntwork-io/terragrunt/issues/892
[optional-object-type]: https://developer.hashicorp.com/terraform/language/expressions/type-constraints#optional-object-type-attributes
[template-function-issue]: https://github.com/hashicorp/terraform/issues/30616
