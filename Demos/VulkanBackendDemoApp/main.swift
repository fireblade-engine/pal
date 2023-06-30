#if FRB_GRAPHICS_VULKAN

    import FirebladePAL

    Platform.initialize()
    print("Platform version: \(Platform.version)")

    func makeVLKSurface(in window: Window) throws -> VLKWindowSurface {
        let vulkanInstance = try VLKWindowSurface.createInstance()
        return try VLKWindowSurface(in: window, instance: vulkanInstance)
    }

    let props = WindowProperties(title: "Vulkan Window", frame: .init(0, 0, 800, 600))

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
