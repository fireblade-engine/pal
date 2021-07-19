//
// APPLAppDelegate.swift
// Fireblade Engine
//
// Copyright © 2018-2021 Fireblade Team. All rights reserved.
// Licensed under GNU General Public License v3.0. See LICENSE file for details.

#if FRB_PLATFORM_APPL

#if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
import AppKit
#elseif FRB_PLATFORM_APPL_IOS || targetEnvironment(macCatalyst)
import UIKit
#endif

class APPLAppDelegate: NSObject, _APPLAppDelegate {
    #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
    var window: _APPLWindow!
    #elseif FRB_PLATFORM_APPL_IOS || targetEnvironment(macCatalyst)
    var window: _APPLWindow?
    #endif

    override init() {
        super.init()

        subscribe(to: _APPLApplication.didBecomeActiveNotification, using: appDidBecomeActive)
        subscribe(to: _APPLApplication.didFinishLaunchingNotification, using: appDidFinishLaunching)
        subscribe(to: _APPLApplication.willResignActiveNotification, using: appWillResignActive)
        subscribe(to: _APPLApplication.willTerminateNotification, using: appWillTerminate)
    }

    private func subscribe(to name: Notification.Name, using handler: @escaping (Notification) -> Void) {
        NotificationCenter.default.addObserver(forName: name,
                                               object: nil,
                                               vkQueue: .main,
                                               using: handler)
    }

    #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }
    #endif
} // -- APPLAppDelegate

// MARK: - Notifications

extension APPLAppDelegate {
    func appDidBecomeActive(_: Notification) {}

    func appDidFinishLaunching(_: Notification) {}

    func appWillResignActive(_: Notification) {}

    func appWillTerminate(_: Notification) {}
}

#endif
