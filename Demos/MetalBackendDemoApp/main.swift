#if FRB_GRAPHICS_METAL

    import FirebladePAL
    import Metal

    Platform.initialize()
    print("Platform version: \(Platform.version)")

    func makeMTLSurface(in window: Window) throws -> MTLWindowSurface {
        let surface = try MTLWindowSurface(in: window, device: MTLCreateSystemDefaultDevice())
        surface.mtlLayer?.backgroundColor = .init(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0)
        return surface
    }

    let props = WindowProperties(title: "Metal Window", frame: .init(0, 0, 800, 600))

    let window = try Window(properties: props,
                            surface: makeMTLSurface)

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
