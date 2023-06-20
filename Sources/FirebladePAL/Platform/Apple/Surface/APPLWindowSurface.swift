//
// APPLWindowSurface.swift
// Fireblade PAL
//
// Copyright © 2018-2023 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

#if FRB_PLATFORM_APPL
    public protocol APPLWindowSurface: WindowSurfaceBase {}

    #if FRB_GRAPHICS_METAL
        public typealias MTLWindowSurface = APPLMTLWindowSurface
    #endif

#endif
