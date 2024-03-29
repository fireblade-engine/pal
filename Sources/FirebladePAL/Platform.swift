//
// Platform.swift
// Fireblade PAL
//
// Copyright © 2018-2023 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

public enum Platform {
    public enum Implementation {
        #if FRB_PLATFORM_SDL
            case sdl
        #endif
        #if FRB_PLATFORM_APPL
            case apple
        #endif
    }

    public static let implementation: Implementation = {
        #if FRB_PLATFORM_SDL
            return .sdl
        #elseif FRB_PLATFORM_APPL
            return .apple
        #else
            #error("No platform support available.")
        #endif
    }()

    public static var version: String {
        switch implementation {
        #if FRB_PLATFORM_SDL
            case .sdl:
                return SDLPlatform.version
        #endif

        #if FRB_PLATFORM_APPL
            case .apple:
                return "<TODO>"
        #endif
        }
    }

    public static func initialize() {
        switch implementation {
        #if FRB_PLATFORM_SDL
            case .sdl:
                SDLPlatform.initialize()
        #endif

        #if FRB_PLATFORM_APPL
            case .apple:
                break
                // APPLPlatform.initialize()
        #endif
        }
    }

    public static func quit() {
        switch implementation {
        #if FRB_PLATFORM_SDL
            case .sdl:
                SDLPlatform.quit()
        #endif

        #if FRB_PLATFORM_APPL
            case .apple:
                break
                // APPLPlatform.quit()
        #endif
        }
    }

    public static var clipboard: Clipboard {
        switch implementation {
        #if FRB_PLATFORM_SDL
            case .sdl:
                return SDLClipboard()
        #endif

        #if FRB_PLATFORM_APPL
            case .apple:
                fatalError("not implemented")
        #endif
        }
    }
}
