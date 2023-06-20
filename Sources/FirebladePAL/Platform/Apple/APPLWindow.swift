//
// APPLWindow.swift
// Fireblade PAL
//
// Copyright © 2018-2023 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

#if FRB_PLATFORM_APPL

    #if canImport(AppKit)
        import AppKit
    #endif

    #if canImport(UIKit)
        import UIKit
    #endif
    import Dispatch
    import FirebladeMath
    import class Foundation.NSObject

    public typealias NativeViewController = _APPLViewController

    public final class APPLWindow: NSObject, WindowBase {
        public var surface: WindowSurface?

        public var windowID: Int

        private let _window: _APPLWindow

        public static func create(with properties: WindowProperties) -> Self {
            Self(properties: properties)
        }

        init(properties: WindowProperties) {
            let view: APPLView
            #if os(macOS)

                let centered = properties.frame.origin == .centerOnScreen

                var contentRect = CGRect(
                    x: centered ? 0 : properties.frame.origin.x,
                    y: centered ? 0 : properties.frame.origin.y,
                    width: properties.frame.size.width,
                    height: properties.frame.size.height
                )

                let styleMask: NSWindow.StyleMask = [.titled, .resizable, .closable, .fullSizeContentView, .miniaturizable]
                _window = _APPLWindow(
                    contentRect: contentRect,
                    styleMask: styleMask,
                    backing: .buffered,
                    defer: false
                )

                windowID = _window.windowNumber

                super.init()
                _window.delegate = self

                registerForDisplayChangeNotifications()

                self.title = properties.title

                if centered {
                    _window.center()
                } else {
                    var origin = CGPoint(x: properties.frame.origin.x, y: properties.frame.origin.y)
                    origin = _window.convertPoint(toScreen: origin)
                    _window.setFrameOrigin(origin)
                }

                contentRect = _window.backingAlignedRect(contentRect, options: .alignAllEdgesOutward)

                view = APPLView(frame: contentRect)
                view.isHidden = false
                view.needsDisplay = true
                view.wantsLayer = true

                _window.contentView = view
                _window.makeKeyAndOrderFront(NSApp)
            #else
                _window = _APPLWindow()

                // _window.rootViewController = viewController
                windowID = -1
                super.init()
            #endif

            // setup view
        }

        deinit {
            deregisterForDisplayChangeNotifications()
        }

        public var title: String? {
            get {
                #if os(macOS) && !targetEnvironment(macCatalyst)
                    return _window.title
                #else
                    return nil
                #endif
            }
            set {
                #if os(macOS) && !targetEnvironment(macCatalyst)
                    _window.title = newValue ?? ""
                #endif
            }
        }

        public var frame: Rect<Int> {
            get {
                Rect<Int>(x: Int(_window.frame.origin.x),
                          y: Int(_window.frame.origin.y),
                          width: Int(_window.frame.size.width),
                          height: Int(_window.frame.size.height))
            }
            set {
                #if os(macOS) && !targetEnvironment(macCatalyst)
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

        public var fullscreen: Bool {
            get {
                #if os(macOS)
                    _window.styleMask.contains(.fullScreen)
                #else
                    return true
                #endif
            }
            set {
                #if os(macOS)
                    if self.fullscreen != newValue {
                        _window.toggleFullScreen(nil)
                    }
                #endif
            }
        }

        public var screen: Screen {
            APPLScreen(_window.screen)!
        }

        var isMain: Bool {
            #if os(macOS) && !targetEnvironment(macCatalyst)
                _window.isMainWindow
            #else
                _window.isKeyWindow
            #endif
        }

        func makeMain() {
            #if os(macOS) && !targetEnvironment(macCatalyst)
                _window.makeMain()
                _window.makeFirstResponder(nil)
            #else
                _window.makeKey()
            #endif
        }

        func makeKeyAndOrderFront() {
            #if os(macOS) && !targetEnvironment(macCatalyst)
                _window.makeKeyAndOrderFront(nil)
                _window.orderFrontRegardless()
            #else
                _window.makeKeyAndVisible()
            #endif
        }

        public func close() {
            deregisterForDisplayChangeNotifications()
            #if os(macOS) && !targetEnvironment(macCatalyst)
                _window.close()
            #endif
        }

        @objc private func handleDisplayChanges(notification _: Notification) {
            // Handle display changes
        }

        private func registerForDisplayChangeNotifications() {
            #if os(macOS) && !targetEnvironment(macCatalyst)
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
            #if os(macOS) && !targetEnvironment(macCatalyst)
                NotificationCenter.default.removeObserver(self, name: _APPLWindow.didChangeScreenNotification, object: nil)
                NotificationCenter.default.removeObserver(self, name: _APPLWindow.didChangeScreenProfileNotification, object: nil)
            #endif
        }
    }

    #if os(macOS) && !targetEnvironment(macCatalyst)

        // MARK: -

        extension APPLWindow: NSWindowDelegate {
            public func windowDidResize(_: Notification) {
                #warning("❗TODO: push window resize event")
            }

            public func windowShouldClose(_: NSWindow) -> Bool {
                #warning("❗TODO: push window close requested event")
                return false
            }
        }
    #endif

#endif
