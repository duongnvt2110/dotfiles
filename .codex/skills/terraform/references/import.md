# Terraform Import

Bring existing infrastructure under Terraform state with verified identifiers and configuration.

## Procedure

1. Identify the exact provider resource and import ID format.
2. Create/confirm matching configuration before import when required.
3. Run import using the repository/provider-supported mechanism.
4. Run plan afterward and resolve unintended drift without masking real differences.
