//
// PlatformInitialization.swift
// Fireblade PAL
//
// Copyright © 2018-2021 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

protocol PlatformInitialization {
    static func initialize()
    static var version: String { get }
    static func quit()
}
