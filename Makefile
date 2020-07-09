DOCKER_TAG ?= bitwarden_rs_ldap_${USER}

.PHONY: all
all: test check release

# Default make target will run tests
.DEFAULT_GOAL = test

# Build debug version
target/debug/bitwarden_rs_ldap: src/
	cargo build

# Build release version
target/release/bitwarden_rs_ldap: src/
	cargo build --locked --release

.PHONY: debug
debug: target/debug/bitwarden_rs_ldap

.PHONY: release
release: target/release/bitwarden_rs_ldap

# Run debug version
.PHONY: run-debug
run-debug: target/debug/bitwarden_rs_ldap
	target/debug/bitwarden_rs_ldap

# Run all tests
.PHONY: test
test:
	cargo test

# Installs pre-commit hooks
.PHONY: install-hooks
install-hooks:
	pre-commit install --install-hooks

# Checks files for encryption
.PHONY: check
check:
	pre-commit run --all-files

# Checks that version matches the current tag
.PHONY: check-version
check-version:
	./scripts/check-version.sh

.PHONY: clean
clean:
	rm -f ./target

.PHONY: docker-build
docker-build:
	docker build -f ./Dockerfile -t $(DOCKER_TAG) .
