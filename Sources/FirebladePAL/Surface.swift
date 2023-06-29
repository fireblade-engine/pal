//
// Surface.swift
// Fireblade PAL
//
// Copyright © 2018-2023 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

import FirebladeMath

#if FRB_PLATFORM_SDL
    public typealias WindowSurface = SDLWindowSurface
#endif

public protocol Surface: AnyObject {
    func destroy()

    func getDrawableSize() -> Size<Int>
}

public protocol WindowSurfaceBase: Surface {
    static func create(in window: Window) throws -> Self

    /// Vertical Synchronization (VSync)
    ///
    /// Helps create stability by synchronzing the image frame rate of your game or application with your display monitor refresh rate.
    /// If it's not synchronized, it can cause screen tearing, an effect that causes the image to look glitched or duplicated horizontally across the screen.
    var enableVsync: Bool { get set }
}

// MARK: - Metal Surface

#if FRB_GRAPHICS_METAL

    import protocol Metal.MTLDevice
    import class QuartzCore.CAMetalLayer

    public protocol MTLSurface: Surface {
        @available(*, deprecated, renamed: "mtlLayer")
        var layer: CAMetalLayer? { get }

        var mtlLayer: CAMetalLayer? { get }
    }

    public protocol MTLWindowSurfaceBase: WindowSurfaceBase, MTLSurface {
        init(in window: Window, device: MTLDevice?) throws
    }

#endif

// MARK: - Vulkan Surface

#if FRB_GRAPHICS_VULKAN

    import Vulkan

    public protocol VLKSurface: Surface {
        var instance: VkInstance { get }
        var surface: VkSurfaceKHR { get }

        static func loadLibrary(_ path: String?)

        /// Create a VkInstance suitable for this surface.
        ///
        /// - Parameters:
        ///   - enabledLayerNames: Names of layers to be enabled.
        ///   - enabledExtensionNames: Names of extensions to be enabled.
        /// - Returns: The new `VkInstance`.
        ///
        /// Should be implemented as an `open class` function.
        /// Implementation should insert required layers and extensions automatically.
        static func createInstance(layers enabledLayerNames: [String], extensions enabledExtensionNames: [String]) throws -> VkInstance

        static func getRequiredInstanceExtensionNames() -> [String]
    }

    public protocol VLKWindowSurfaceBase: WindowSurfaceBase, VLKSurface {
        init(in window: Window, instance: VkInstance) throws
    }
#endif

// MARK: - OpenGL Surface

#if FRB_GRAPHICS_OPENGL
    public protocol OpenGLContextBase {
        func makeCurrent()
    }

    public protocol OpenGLSurface: Surface {
        associatedtype OpenGLContext: OpenGLContextBase
        var glContext: OpenGLContext { get }
    }

    public protocol OpenGLWindowSurfaceBase: WindowSurfaceBase, OpenGLSurface {}
#endif

// MARK: - CPU Surface

public protocol CPUSurface: Surface {
    var buffer: UnsafeMutableBufferPointer<UInt8> { get }
}

public protocol CPUWindowSurfaceBase: WindowSurfaceBase, CPUSurface {}
