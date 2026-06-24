.DEFAULT_GOAL := help

.PHONY: help install brew symlinks macos dump lint

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

install: ## Full fresh-Mac bootstrap (brew, shell, symlinks, macOS defaults)
	./install.sh

brew: ## Install/upgrade everything in the Brewfile
	brew bundle --file=Brewfile

symlinks: ## Symlink dotfiles into $HOME (backs up existing files)
	./scripts/link.sh

macos: ## Apply macOS defaults
	./macos/defaults.sh

dump: ## Regenerate the Brewfile from what is currently installed
	brew bundle dump --force --file=Brewfile

lint: ## Shellcheck all shell scripts
	shellcheck install.sh scripts/*.sh macos/*.sh
