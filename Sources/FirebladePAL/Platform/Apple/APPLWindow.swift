//
// APPLWindow.swift
// Fireblade Engine
//
// Copyright © 2018-2021 Fireblade Team. All rights reserved.
// Licensed under GNU General Public License v3.0. See LICENSE file for details.

#if FRB_PLATFORM_APPL

#if FRB_PLATFORM_APPL_MACOS
import AppKit
import protocol AppKit.NSWindowDelegate
#elseif FRB_PLATFORM_APPL_IOS
import UIKit
#endif
import Dispatch
import class Foundation.NSObject
import FirebladeMath

public typealias NativeViewController = _APPLViewController

final class APPLWindow: NSObject, WindowBase {
    private let _window: _APPLWindow
    private let _viewController: APPLViewController

    init(properties _: WindowProperties) {
        fatalError()
    }

    init(manager: APPLWindowManager,
         viewController: APPLViewController,
         properties _: WindowProperties,
         nativeWindow: _APPLWindow? = nil)
    {
        self.manager = manager
        self._viewController = viewController
        #if FRB_PLATFORM_APPL_MACOS
        _window = nativeWindow ?? _APPLWindow(contentRect: .zero,
                                              styleMask: [.titled, .resizable, .closable, .fullSizeContentView, .miniaturizable],
                                              backing: .buffered,
                                              defer: false)
        _window.contentView = viewController.view
        _window.contentViewController = viewController
        super.init()
        _window.delegate = self
        registerForDisplayChangeNotifications()
        #else
        _window = nativeWindow ?? _APPLWindow()
        _window.rootViewController = viewController
        super.init()
        #endif
    }

    deinit {
        deregisterForDisplayChangeNotifications()
    }

    var title: String? {
        get {
            #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
            return _window.title
            #else
            return nil
            #endif
        }
        set {
            #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
            _window.title = newValue ?? ""
            #endif
        }
    }

    var frame: Rect<Int> {
        get {
            Rect<Int>(x: Int(_window.frame.origin.x),
                      y: Int(_window.frame.origin.y),
                      width: Int(_window.frame.size.width),
                      height: Int(_window.frame.size.height))
        }
        set {
            #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
            let frame = CGRect(x: CGFloat(newValue.origin.x),
                               y: CGFloat(newValue.origin.y),
                               width: CGFloat(newValue.size.width),
                               height: CGFloat(newValue.size.height))
            _window.setFrame(frame, display: true)
            #else
            // _window.frame = .init(rect: newValue)
            #endif
        }
    }

    var fullscreen: Bool {
        get {
            _window.styleMask.contains(.fullScreen)
        }
        set {
            if self.fullscreen != newValue {
                _window.toggleFullScreen(nil)
            }
        }
    }

    var screen: Screen? {
        APPLScreen(_window.screen)
    }

    var isMain: Bool {
        #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
        _window.isMainWindow
        #else
        _window.isKeyWindow
        #endif
    }

    func makeMain() {
        #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
        _window.makeMain()
        _window.makeFirstResponder(nil)
        #else
        _window.makeKey()
        #endif
    }

    func centerOnScreen() {
        #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
        _window.center()
        #endif
    }

    func makeKeyAndOrderFront() {
        #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
        _window.makeKeyAndOrderFront(nil)
        _window.orderFrontRegardless()
        #else
        _window.makeKeyAndVisible()
        #endif
    }

    func close() {
        deregisterForDisplayChangeNotifications()
        #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
        _window.close()
        #endif
    }

    @objc private func handleDisplayChanges(notification: Notification) {
        // Handle display changes
    }

    private func registerForDisplayChangeNotifications() {
        #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleDisplayChanges(notification:)),
                                               name: _APPLWindow.didChangeScreenNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleDisplayChanges(notification:)),
                                               name: _APPLWindow.didChangeScreenProfileNotification,
                                               object: nil)
        #endif
    }

    private func deregisterForDisplayChangeNotifications() {
        #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
        NotificationCenter.default.removeObserver(self, name: _APPLWindow.didChangeScreenNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: _APPLWindow.didChangeScreenProfileNotification, object: nil)
        #endif
    }
}

#if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)

// MARK: -

extension APPLWindow: NSWindowDelegate {
    func windowDidResize(_: Notification) {
        #warning("❗TODO: push window resize event")
    }

    func windowShouldClose(_: NSWindow) -> Bool {
        #warning("❗TODO: push window close requested event")
        return false
    }
}
#endif

#endif
