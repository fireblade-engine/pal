.PHONY: lint-fix
lint-fix:
	swiftlint --fix --format
	swiftlint lint --quiet

.PHONY: test
test:
	swift test -v --skip-update --parallel --enable-test-discovery --enable-code-coverage

.PHONY: build-release
build-release:
	swift build -c release

.PHONY: brew-setup
brew-setup:
	which -s brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	brew update

.PHONY: install-dependencies
install-dependencies: brew-setup
	brew install sdl2

.PHONY: open-proj
open-proj: 
	open Package.swift
