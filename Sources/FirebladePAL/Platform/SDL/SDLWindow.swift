//
// SDLWindow.swift
// Fireblade PAL
//
// Copyright © 2018-2021 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

#if FRB_PLATFORM_SDL

    import FirebladeMath
    @_implementationOnly import SDL2

    typealias SDL_Window = OpaquePointer

    open class SDLWindow: WindowBase {
        public let surfaceType: WindowSurface.Type

        internal var _surface: SDLWindowSurface?
        internal let _window: SDL_Window

        public required init<Surface>(properties: WindowProperties, surface surfaceConstructor: @escaping SurfaceConstructor<Surface>) throws where Surface: SDLWindowSurface {
            var flags = SDL_WINDOW_SHOWN.rawValue | SDL_WINDOW_ALLOW_HIGHDPI.rawValue | SDL_WINDOW_RESIZABLE.rawValue | SDL_WINDOW_INPUT_FOCUS.rawValue

            let originX: Int32 = (properties.frame.origin == .centerOnScreen) ? Int32(SDL_WINDOWPOS_CENTERED_MASK) : Int32(properties.frame.origin.x)
            let originY: Int32 = (properties.frame.origin == .centerOnScreen) ? Int32(SDL_WINDOWPOS_CENTERED_MASK) : Int32(properties.frame.origin.y)

            surfaceType = Surface.self
            flags |= Surface.sdlFlags

            guard let window = SDL_CreateWindow(properties.title,
                                                originX,
                                                originY,
                                                Int32(properties.frame.width),
                                                Int32(properties.frame.height),
                                                flags)
            else {
                throw SDLError()
            }

            _window = window
            _surface = try surfaceConstructor(self)
        }

        public required init(properties: WindowProperties, surfaceType: WindowSurface.Type) throws {
            var flags = SDL_WINDOW_SHOWN.rawValue | SDL_WINDOW_ALLOW_HIGHDPI.rawValue | SDL_WINDOW_RESIZABLE.rawValue | SDL_WINDOW_INPUT_FOCUS.rawValue

            let originX: Int32 = (properties.frame.origin == .centerOnScreen) ? Int32(SDL_WINDOWPOS_CENTERED_MASK) : Int32(properties.frame.origin.x)
            let originY: Int32 = (properties.frame.origin == .centerOnScreen) ? Int32(SDL_WINDOWPOS_CENTERED_MASK) : Int32(properties.frame.origin.y)

            flags |= surfaceType.sdlFlags
            self.surfaceType = surfaceType

            guard let window = SDL_CreateWindow(properties.title,
                                                originX,
                                                originY,
                                                Int32(properties.frame.width),
                                                Int32(properties.frame.height),
                                                flags)
            else {
                throw SDLError()
            }

            _window = window
        }

        deinit {
            surface?.destroy()
        }

        open class func createSurface(of surfaceType: WindowSurface.Type, in window: Window) throws -> WindowSurface {
            try surfaceType.create(in: window)
        }

        public var surface: WindowSurface? {
            if _surface == nil {
                do {
                    _surface = try Self.createSurface(of: surfaceType, in: self)
                } catch {
                    assertionFailure("\(error)")
                }
            }
            return _surface
        }

        public lazy var windowID = Int(SDL_GetWindowID(_window))

        public var title: String? {
            get { String(cString: SDL_GetWindowTitle(_window)) }
            set { SDL_SetWindowTitle(_window, newValue) }
        }

        public var frame: Rect<Int> {
            get {
                var x: Int32 = 0, y: Int32 = 0, w: Int32 = 0, h: Int32 = 0
                SDL_GetWindowPosition(_window, &x, &y)
                SDL_GetWindowSize(_window, &w, &h)
                return Rect(Int(x), Int(y), Int(w), Int(h))
            }
            set {
                SDL_SetWindowPosition(_window, Int32(newValue.origin.x), Int32(newValue.origin.y))
                SDL_SetWindowSize(_window, Int32(newValue.size.width), Int32(newValue.size.height))
            }
        }

        public var fullscreen: Bool {
            get {
                (SDL_GetWindowFlags(_window) & SDL_WINDOW_FULLSCREEN.rawValue) == SDL_WINDOW_FULLSCREEN.rawValue
            }
            set {
                let result = SDL_SetWindowFullscreen(_window, newValue ? SDL_WINDOW_FULLSCREEN.rawValue : 0)
                SDLAssert(result == 0)
            }
        }

        public var screen: Screen? {
            let displayIndex = SDL_GetWindowDisplayIndex(_window)
            SDLAssert(displayIndex == 0)
            return SDLScreen(displayIndex: displayIndex)
        }

        public func close() {
            SDL_DestroyWindow(_window)
        }

        public func centerOnScreen() {
            SDL_SetWindowPosition(_window, Int32(SDL_WINDOWPOS_CENTERED_MASK), Int32(SDL_WINDOWPOS_CENTERED_MASK))
        }
    }

#endif
