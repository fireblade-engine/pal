//
// APPLScreen.swift
// Fireblade PAL
//
// Copyright © 2018-2023 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

#if FRB_PLATFORM_APPL

    #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
        import AppKit
        import CoreGraphics
    #elseif FRB_PLATFORM_APPL_IOS || targetEnvironment(macCatalyst)
        import UIKit
    #endif
    import FirebladeMath

    final class APPLScreen: Screen {
        let native: _APPLScreen

        init?(_ native: _APPLScreen?) {
            guard let screen = native else {
                return nil
            }
            self.native = screen
        }

        static var main: Screen? {
            APPLScreen(_APPLScreen.main)
        }

        static var screens: [Screen] {
            _APPLScreen.screens.compactMap(APPLScreen.init)
        }

        var frame: Rect<Int> {
            #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
                // The dimensions and location of the screen.
                // The current location and dimensions of the visible screen.
                Rect(Int(native.frame.origin.x),
                     Int(native.frame.origin.y),
                     Int(native.frame.size.width),
                     Int(native.frame.size.height))
            #else
                // bounds - // Bounds of entire screen in points - The bounding rectangle of the screen, measured in points.
                // nativeBounds - Native bounds of the physical screen in pixels - The bounding rectangle of the physical screen, measured in pixels.
                Rect(rect: native.bounds)
            #endif
        }

        var scale: Float {
            #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
                // The backing store pixel scale factor for the screen.
                return Float(native.backingScaleFactor)
            #else
                // Native scale factor of the physical screen
                // native.nativeScale
                // The natural scale factor associated with the screen.
                return Float(native.scale)
            #endif
        }

        var isMain: Bool {
            _APPLScreen.main === native
        }

        #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
            private var displayID: CGDirectDisplayID? {
                #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
                    return native.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID
                #else
                    return nil
                #endif
            }

            private var displayMode: CGDisplayMode? {
                guard let displayID else {
                    return nil
                }

                return CGDisplayCopyDisplayMode(displayID)
            }
        #endif

        var screenID: Int? {
            #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
                return displayID.map(Int.init)
            #else
                return nil
            #endif
        }

        var refreshRate: Int? {
            #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
                guard let displayMode else {
                    return nil
                }
                return Int(displayMode.refreshRate.rounded(.toNearestOrEven))
            #else
                return native.maximumFramesPerSecond
            #endif
        }
    }

#endif
