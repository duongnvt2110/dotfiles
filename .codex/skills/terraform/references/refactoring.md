# Terraform Refactoring

Refactor Terraform without accidentally changing resource identity or forcing replacement.

## Procedure

1. Compare current and target resource/module addresses.
2. Check state/address implications before moving blocks or changing keys.
3. Use `moved`/import/state-compatible mechanisms when required.
4. Review plan output for replacement/destruction before accepting the refactor.
5. Keep semantic behavior unchanged unless the request explicitly changes it.
