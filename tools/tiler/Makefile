.PHONY: help ## show this help message
help:
	@echo 'Usage: make [target]'
	@echo 'Targets:'
	@awk 'BEGIN {FS = " ## "} /^\.PHONY: [a-zA-Z_-]+ ## / {sub(/^\.PHONY: /, "", $$1); printf "  %-10s - %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: install ## install dependencies
install: 
	@uv sync --exact --all-groups

.PHONY: outdated ## check top level packages for newer versions
outdated:
	@uv tree --outdated --depth 1

.PHONY: upgrade ## upgrade dependencies (within constraints)
upgrade: 
	@uv lock --upgrade

.PHONY: lint ## run linter and type checker
lint:
	@uv run ruff check --fix .
	@uv run mypy .

.PHONY: clean ## clean up build artifacts
clean: 
	@rm -f *.bin *.html
	@rm -rf build dist memray
	@rm -rf .coverage .coverage.*
	@rm -rf .pytest_cache .mypy_cache .ruff_cache
	@find . -type d -name "*.egg-info" -exec rm -rf {} +
	@find . -type d -name __pycache__ -exec rm -rf {} +
	@find . -type f -name "*.pyc" -delete
