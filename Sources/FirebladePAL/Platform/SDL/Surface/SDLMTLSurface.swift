//
// SDLMTLSurface.swift
// Fireblade PAL
//
// Copyright © 2018-2023 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

#if FRB_PLATFORM_SDL && FRB_GRAPHICS_METAL

    import func Metal.MTLCreateSystemDefaultDevice
    import protocol Metal.MTLDevice
    import class QuartzCore.CAMetalLayer
    @_implementationOnly import SDL

    import FirebladeMath

    open class SDLMTLWindowSurface: SDLWindowSurface, MTLWindowSurfaceBase {
        private weak var _window: SDLWindow?

        private var mtlView: SDL_MetalView!
        public var mtlLayer: CAMetalLayer?

        public static var sdlFlags: UInt32 = SDL_WINDOW_METAL.rawValue

        public var enableVsync: Bool {
            get {
                #if os(macOS)
                    mtlLayer?.displaySyncEnabled ?? false
                #else
                    false
                #endif
            }
            set {
                #if os(macOS)
                    mtlLayer?.displaySyncEnabled = newValue
                #endif
            }
        }

        public required init(in window: SDLWindow, device: MTLDevice?) throws {
            guard let mtlView = SDL_Metal_CreateView(window._window) else {
                throw SDLError()
            }
            self.mtlView = mtlView

            let mtlLayer = unsafeBitCast(SDL_Metal_GetLayer(mtlView), to: CAMetalLayer.self)

            self._window = window
            self.mtlLayer = mtlLayer
            if let device {
                mtlLayer.device = device
            }
        }

        public static func create(in window: Window) throws -> Self {
            try Self(in: window, device: MTLCreateSystemDefaultDevice())
        }

        deinit {
            destroy()
        }

        public func destroy() {
            SDL_Metal_DestroyView(mtlView)
            mtlView = nil
            self.mtlLayer = nil
            self._window = nil
        }

        public func getDrawableSize() -> Size<Int> {
            guard let window = _window else {
                return Size(width: -1, height: -1)
            }
            var w: Int32 = 0
            var h: Int32 = 0
            SDL_Metal_GetDrawableSize(window._window, &w, &h)
            return Size(width: Int(w), height: Int(h))
        }
    }

#endif
