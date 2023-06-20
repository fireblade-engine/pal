//
// main.swift
// Fireblade PAL
//
// Copyright © 2018-2021 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

import FirebladePAL

Platform.initialize()
print("Platform version: \(Platform.version)")

// either use a custom surface sub-class
// or use the default implementation directly
// let surface = CPUSurface()

let props = WindowProperties(title: "Title", frame: .init(0, 0, 800, 600))
let window = try Window.create(with: props)

let surface = try CPUWindowSurface.create()
window.surface = surface

var event = Event()

var quit = false

while !quit {
    Events.pumpEvents()

    while Events.pollEvent(&event) {
        switch event.variant {
        case .userQuit:
            quit = true

        case .window:
            if case .resizedTo = event.window.action {
                try surface.handleWindowResize()
            }

        default:
            break
        }
    }

    surface.clear()
    surface.flush()
}

Platform.quit()

