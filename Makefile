SWIFT_PACKAGE_VERSION := $(shell swift package tools-version)
SOURCES_DIR="${PWD}/Sources"

# Delete package build artifacts.
.PHONY: clean
clean:
	swift package clean

# Lint fix and format code.
.PHONY: lint-fix
lint-fix: format-headers
	mint run swiftlint --fix --quiet
	mint run swiftformat --quiet --swiftversion ${SWIFT_PACKAGE_VERSION} .

.PHONY: format-headers
format-headers:
	# Format header
	mint run swiftformat ${SOURCES_DIR} --exclude **/*.generated.swift --header "\n{file}\nFireblade PAL\n\nCopyright © 2018-{year} Fireblade Team. All rights reserved.\nLicensed under MIT License. See LICENSE file for details." --swiftversion ${SWIFT_PACKAGE_VERSION}

.PHONY: pre-push
pre-push: genLinuxTests update-fileheaders lint-fix

# Build debug version
.PHONY: build-debug
build-debug:
	swift build -c debug

# Build release version 
.PHONY: build-release
build-release:
	swift build -c release --skip-update

# Reset the complete cache/build directory and Package.resolved files
.PHONY: reset
	swift package reset
	-rm Package.resolved
	-rm rdf *.xcworkspace/xcshareddata/swiftpm/Package.resolved
	-rm -rdf .swiftpm/xcode/*

.PHONY: resolve
resolve:
	swift package resolve

.PHONY: open-proj-xcode
open-proj-xcode:
	open -b com.apple.dt.Xcode Package.swift

.PHONY: open-proj-vscode
open-proj-vscode:
	code .

.PHONY: setup-brew
setup-brew:
	@which -s brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	@brew update

.PHONY: install-dependencies
install-dependencies: brew-setup
	brew install sdl2

.PHONY: open-proj
open-proj: 
	open Package.swift

.PHONY: test
test:
	swift test -v --skip-update --enable-test-discovery

.PHONY: genLinuxTests
genLinuxTests:
	swift test --generate-linuxmain
	mint run swiftlint --fix --format --path Tests/

.PHONY: update-fileheaders
update-fileheaders:
	Scripts/update-fileheaders.sh
