//
//  File.swift
//  
//
//  Created by Christian Treffs on 13.06.23.
//

#if FRB_PLATFORM_APPL

#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif

open class APPLApp: NSObject, AppBase, _APPLAppDelegate {

    public override required init() {
        super.init()
    }

    public static func main() throws {

        // https://github.com/libsdl-org/SDL/blob/main/src/video/cocoa/SDL_cocoaevents.m#L450
        #if os(macOS)
        let nsApp = NSApplication.shared
        let app = Self()

        nsApp.delegate = app
        nsApp.setActivationPolicy(.regular)

        let mainMenu = NSMenu()
        let mainAppMenuItem     = NSMenuItem(title: "Application", action: nil, keyEquivalent: "")
        mainMenu.addItem(mainAppMenuItem)
        let appMenu             = NSMenu()
        mainAppMenuItem.submenu = appMenu
        appMenu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        nsApp.mainMenu = mainMenu

        if #available(macOS 14.0, *) {
            nsApp.activate()
        } else {
            nsApp.activate(ignoringOtherApps: true)
        }
        
        _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
        #elseif os(iOS) || os(tvOS)


        let uiApp = UIApplication.shared

        let app = APPLApp()


        uiApp.delegate = app
        let delegateClassName = NSStringFromClass(APPLApp.self)

        UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, delegateClassName)

        #else
        #error("unsupported Apple platform")
        #endif
    }


    private func subscribe(to name: Notification.Name, using handler: @escaping (Notification) -> Void) {
        NotificationCenter.default.addObserver(forName: name,
                                               object: nil,
                                               queue: .main,
                                               using: handler)
    }

#if os(macOS)
    public func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }
#endif

    public func applicationDidFinishLaunching(_ notification: Notification) {
        appDidLaunch()
    }

    public func applicationWillTerminate(_ notification: Notification) {
        appWillTerminate()
    }

    open func appDidLaunch() { /* override in subclass */ }

    open func appWillTerminate() { /* override in subclass */ }


}


#endif
