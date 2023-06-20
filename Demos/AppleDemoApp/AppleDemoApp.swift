import FirebladePAL
import Metal

@main
final class DemoApp: App {

    var windows: [Window] = []

    override func appDidLaunch() {
        var desc = WindowProperties(title: "Window 1", frame: .init(origin: .centerOnScreen, size: .init(width: 800, height: 600)))
        print("app did launch")
        let window = Window.create(with: desc)
        windows.append(window)

        desc.title = "Window 2"
        desc.frame.x = 0
        desc.frame.y = 0
        desc.frame.width = 600
        desc.frame.height = 800
        let window2 = Window.create(with: desc)
        windows.append(window2)

        //let surface: MTLWindowSurface = MTLWindowSurface(device: MTLCreateSystemDefaultDevice())
        //window.surface = surface

        while true {
            Events.pumpEvents()
        }
    }

    func appOnEvent(event: Event) {
        switch event.variant {
        case .keyboard:
            handleEvent(keyboard: event.keyboard)
        case .window:
            handleEvent(window: event.window)
        default:
            break

        }
    }

    override func appWillTerminate() {
        print("app will shut down")
    }

    func handleEvent(keyboard event: KeyboardEvent) {
        guard
            event.state == .released,
            let window = windows.first(where: { $0.windowID == event.windowID })
        else {
            return
        }

        switch event.virtualKey {
        case .ESCAPE where window.fullscreen:
            window.fullscreen = false
        case .F:
            window.fullscreen.toggle()
        default:
            break

        }
    }

    func handleEvent(window event: WindowEvent) {
        dump(event)
    }
}
