//
// SDLWindowSurface.swift
// Fireblade PAL
//
// Copyright © 2018-2021 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

#if FRB_PLATFORM_SDL

    public protocol SDLWindowSurface: WindowSurfaceBase {
        static var sdlFlags: UInt32 { get }
    }

    public typealias CPUWindowSurface = SDLCPUWindowSurface

    #if FRB_GRAPHICS_VULKAN
        public typealias VLKWindowSurface = SDLVLKWindowSurface
    #endif

    #if FRB_GRAPHICS_METAL
        public typealias MTLWindowSurface = SDLMTLWindowSurface
    #endif

    #if FRB_GRAPHICS_OPENGL
        public typealias OpenGLWindowSurface = SDLOpenGLWindowSurface
    #endif

#endif
