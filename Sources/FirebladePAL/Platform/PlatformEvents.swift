//
// PlatformEvents.swift
// Fireblade PAL
//
// Copyright © 2018-2021 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

protocol PlatformEvents {
    /// Pump the event loop, gathering events from the input devices.
    func pumpEvents()

    func pollEvent(_ event: inout Event) -> Bool

    // func pushEvent(_ event: Event)
}
