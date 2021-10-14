//
// main.swift
// Fireblade Engine
//
// Created by Adrian Zimmermann on 18.04.2021.
//
// Copyright © 2021 Fireblade Team. All rights reserved.
// Licensed under GNU General Public License v3.0. See LICENSE file for details.

#if FRB_GRAPHICS_VULKAN

import FirebladePAL

Platform.initialize()
print("Platform version: \(Platform.version)")

func makeVLKSurface(in window: Window) throws -> VLKWindowSurface {
    let vulkanInstance = try VLKWindowSurface.createInstance()
    return try VLKWindowSurface(in: window, instance: vulkanInstance)
}

let props = WindowProperties(title: "Title", frame: .init(0, 0, 800, 600))

let window = try Window(properties: props,
                        surface: makeVLKSurface)

var event = Event()
var quit = false

while !quit {
    Events.pumpEvents()

    while Events.pollEvent(&event) {
        switch event.variant {
        case .userQuit:
            quit = true

        default:
            break
        }
    }
}

Platform.quit()

#endif
