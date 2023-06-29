//
// main.swift
// Fireblade PAL
//
// Copyright © 2018-2023 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

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
