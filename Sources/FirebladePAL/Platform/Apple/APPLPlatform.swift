//
// APPLPlatform.swift
// Fireblade PAL
//
// Copyright © 2018-2021 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

#if FRB_PLATFORM_APPL

#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif

enum APPLPlatform: PlatformInitialization {
    static var version: String {
        return ProcessInfo.processInfo.operatingSystemVersionString
    }

    static func initialize() {

        //let app = NSApplication.shared
        //let delegate = AppDelegate()
        //app.delegate = delegate

        // 2
        

        /*_ = NSApplication.shared
        let app = NSApp!
        app.setActivationPolicy(.regular)

        if #available(macOS 14.0, *) {
            app.activate()
        } else {
            app.activate(ignoringOtherApps: true)

        }*/


    }

    static func quit() {
#warning("❗TODO: quit APPLPlatform")
    }
/*
    static func main() -> Int {
#if os(macOS) && !targetEnvironment(macCatalyst)
        return Int(mainAppKit())
#else
        return Int(mainUIKit())
#endif
    }

#if os(macOS) && !targetEnvironment(macCatalyst)

    // MARK: - AppKit

    static func mainAppKit() -> Int32 {
        let nsApp = _APPLApplication.shared
        let strongDelegate = APPLAppDelegate()

        nsApp.delegate = strongDelegate
        let status = NSApplicationMain(CommandLine.argc,
                                       CommandLine.unsafeArgv)

        return status
    }

#elseif FRB_PLATFORM_APPL_IOS || targetEnvironment(macCatalyst)

    // MARK: - UIKit

    static func mainUIKit(app: AppDelegate) -> Int32 {
        APPLAppDelegate.app = app
        let status = UIApplicationMain(
            CommandLine.argc,
            CommandLine.unsafeArgv,
            nil,
            NSStringFromClass(APPLAppDelegate.self)
        )
        return status
    }
#endif
 */
} // -- APPLAppMain

#endif
