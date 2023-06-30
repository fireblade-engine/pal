import FirebladePAL

Platform.initialize()
print("Platform version: \(Platform.version)")

// either use a custom surface sub-class
// or use the default implementation directly
// let surface = CPUSurface()
let window = try Window(
    properties: WindowProperties(title: "Title", frame: .init(0, 0, 800, 600)),
    surface: { try CPUWindowSurface(in: $0) }
)

guard let surface = window.surface as? CPUWindowSurface else {
    fatalError("no window surface")
}

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
