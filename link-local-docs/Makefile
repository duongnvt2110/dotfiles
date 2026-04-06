SHELL := /bin/bash

SCRIPT ?= project-link
LOCAL_SCRIPT := ./project-link.sh
SETUP_SCRIPT := ./scripts/setup-project-link.sh
LINK_NAME ?= my_docs
PROJECT_LINK_ROOT ?= $(CURDIR)

.PHONY: help setup \
	link-local-docs status-local-docs repair-local-docs \
	link status repair check

help:
	@echo "Targets:"
	@echo "  make setup              install global project-link and update ~/.zshrc"
	@echo "  make link-local-docs    [LINK_NAME=<name>] [PROJECT_LOCAL_HOME=<path>]"
	@echo "  make status-local-docs  [LINK_NAME=<name>] [PROJECT_LOCAL_HOME=<path>]"
	@echo "  make repair-local-docs  [LINK_NAME=<name>] [PROJECT_LOCAL_HOME=<path>]"
	@echo "  make check"
	@echo "Default command: $(SCRIPT) (falls back to $(LOCAL_SCRIPT) if missing)"
	@echo "Project root override: PROJECT_LINK_ROOT=$(PROJECT_LINK_ROOT)"
	@echo "Aliases: link, status, repair"

setup:
	@$(SETUP_SCRIPT)

link-local-docs:
	@cmd="$(SCRIPT)"; command -v "$$cmd" >/dev/null 2>&1 || cmd="$(LOCAL_SCRIPT)"; \
	PROJECT_LINK_ROOT="$(PROJECT_LINK_ROOT)" PROJECT_LOCAL_HOME="$(PROJECT_LOCAL_HOME)" "$$cmd" link $(LINK_NAME)

status-local-docs:
	@cmd="$(SCRIPT)"; command -v "$$cmd" >/dev/null 2>&1 || cmd="$(LOCAL_SCRIPT)"; \
	PROJECT_LINK_ROOT="$(PROJECT_LINK_ROOT)" PROJECT_LOCAL_HOME="$(PROJECT_LOCAL_HOME)" "$$cmd" status $(LINK_NAME)

repair-local-docs:
	@cmd="$(SCRIPT)"; command -v "$$cmd" >/dev/null 2>&1 || cmd="$(LOCAL_SCRIPT)"; \
	PROJECT_LINK_ROOT="$(PROJECT_LINK_ROOT)" PROJECT_LOCAL_HOME="$(PROJECT_LOCAL_HOME)" "$$cmd" repair $(LINK_NAME)

# Backward-compatible aliases
link: link-local-docs
status: status-local-docs
repair: repair-local-docs

check:
	@bash -n $(LOCAL_SCRIPT)
	@bash -n $(SETUP_SCRIPT)
	@echo "Syntax check passed: $(LOCAL_SCRIPT) and $(SETUP_SCRIPT)"
