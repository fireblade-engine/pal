//
// APPLScreen.swift
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
import CoreGraphics
import FirebladeMath

public final class APPLScreen: ScreenBase {

    
        let native: _APPLScreen

        init?(_ native: _APPLScreen?) {
            guard let screen = native else {
                return nil
            }
            self.native = screen
        }

    public static var main: Screen {
            APPLScreen(_APPLScreen.main)!
        }

    public static var screens: [Screen] {
            _APPLScreen.screens.compactMap(APPLScreen.init)
        }

    public var name: String? {
        #if os(macOS)
        return native.localizedName
        #else
        return nil
        #endif
    }

    public var frame: Rect<Int> {
            #if os(macOS)
                // The dimensions and location of the screen.
                // The current location and dimensions of the visible screen.
                Rect(Int(native.frame.origin.x),
                     Int(native.frame.origin.y),
                     Int(native.frame.size.width),
                     Int(native.frame.size.height))
            #else
                // bounds - // Bounds of entire screen in points - The bounding rectangle of the screen, measured in points.
                // nativeBounds - Native bounds of the physical screen in pixels - The bounding rectangle of the physical screen, measured in pixels.
                return Rect(Int(native.bounds.origin.x),
                     Int(native.bounds.origin.y),
                     Int(native.bounds.size.width),
                     Int(native.bounds.size.height))
            #endif
        }

        var scale: Float {
            #if os(macOS)
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

        #if os(macOS)
            private var displayID: CGDirectDisplayID? {
                #if os(macOS) && !targetEnvironment(macCatalyst)
                    return native.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID
                #else
                    return nil
                #endif
            }

            private var displayMode: CGDisplayMode? {
                guard let displayID = displayID else {
                    return nil
                }

                return CGDisplayCopyDisplayMode(displayID)
            }
        #endif

    public var screenID: Int? {
            #if os(macOS)
                return displayID.map(Int.init)
            #else
                return nil
            #endif
        }

    public var refreshRate: Int? {
            #if os(macOS)
                guard let displayMode = displayMode else {
                    return nil
                }
                return Int(displayMode.refreshRate.rounded(.toNearestOrEven))
            #else
                return native.maximumFramesPerSecond
            #endif
        }
    }

#endif
