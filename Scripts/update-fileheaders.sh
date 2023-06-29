#!/usr/bin/env bash

SOURCES_DIR="${PWD}/Sources"
FILEHEADER="\n{file}\nFireblade PAL\n\nCopyright © 2018-{year} Fireblade Team. All rights reserved.\nLicensed under MIT License. See LICENSE file for details."

# Format header
mint run swiftformat $SOURCES_DIR --exclude **/*.generated.swift --header "$FILEHEADER" --swiftversion `swift package tools-version`
