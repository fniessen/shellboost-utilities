.DEFAULT_GOAL := help
.PHONY: help all lint-shell

# Show this help.
help:
	@printf '%s\n' "Usage: make TARGET" "" "Targets:"
	@awk '\
	/^[[:space:]]*#[[:space:]]/ { \
		description = $$0; \
		sub(/^[[:space:]]*#[[:space:]]*/, "", description); \
		next; \
	} \
	/^[a-zA-Z0-9_-]+:/ { \
		target = $$0; \
		sub(/:.*/, "", target); \
		printf "  %-15s %s\n", target, description; \
		description = ""; \
		next; \
	} \
	{ description = "" }' [Mm]akefile

# Run all available checks.
all: lint-shell

# Run ShellCheck on shell scripts in the repository.
lint-shell:
	@command -v shellcheck >/dev/null || { printf 'ShellCheck is required.\n' >&2; exit 127; }
	@find . -type f -not -path './.git/*' \
		\( -perm /111 -o -name '*.sh' -o -name '*.bash' \) -print0 \
		| xargs -0 -r grep -IlZ -m1 -E '^#!.*(bash|/sh|/dash|/ksh)([[:space:]]|$$)' \
		| xargs -0 -r shellcheck
	shellcheck -s bash bin/rc-common-settings-shellboost-utilities
