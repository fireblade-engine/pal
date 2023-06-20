
#if FRB_PLATFORM_SDL
public typealias App = AnyObject
#elseif FRB_PLATFORM_APPL
public typealias App = APPLApp
#endif

public protocol AppBase {
    init()

    func appDidLaunch()
    func appWillTerminate()
}

/*
// MARK: - public
extension App {

    public static func create() -> Self {
        
    }

    public static func main() throws {
        Platform.initialize()
        let app = Self.create()
        app.appDidLaunch()
        app.appEventLoop()
        app.appWillShutDown()

        Platform.quit()
    }

    public func appDidLaunch() {
        /* app did launch */
    }

    public func appEventLoop() {
        var event = Event()
        var quitApp = false

        while !quitApp {
            Events.pumpEvents()

            while Events.pollEvent(&event) {
                switch event.variant {
                case .userQuit:
                    appOnEvent(event: event)
                    quitApp = true
                default:
                    appOnEvent(event: event)
                }
            }
        }

    }

    public func appWillShutDown() {
        /* app will shutdown */
    }


}
 */


public protocol AppContext {
    var isRunning: Bool { get set }
}

public class DefaultAppContext: AppContext {
    public var isRunning: Bool = false
}

