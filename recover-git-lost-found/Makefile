SHELL := /bin/bash

SCRIPT ?= recover-git-lost-found
LOCAL_SCRIPT := ./export-lost-found-objects.sh
SETUP_SCRIPT := ./scripts/setup-recover-git-lost-found.sh

.PHONY: help setup run install-global check

help:
	@echo "Targets:"
	@echo "  make setup            install global recover-git-lost-found into ~/.local/bin"
	@echo "  make run              run recovery (global command fallback to local script)"
	@echo "  make install-global   alias of setup"
	@echo "  make check            syntax check scripts"
	@echo "Default command: $(SCRIPT) (falls back to $(LOCAL_SCRIPT) if missing)"

setup:
	@$(SETUP_SCRIPT)

install-global: setup

run:
	@cmd="$(SCRIPT)"; command -v "$$cmd" >/dev/null 2>&1 || cmd="$(LOCAL_SCRIPT)"; \
	"$$cmd"

check:
	@bash -n $(LOCAL_SCRIPT)
	@bash -n $(SETUP_SCRIPT)
	@echo "Syntax check passed: $(LOCAL_SCRIPT) and $(SETUP_SCRIPT)"
