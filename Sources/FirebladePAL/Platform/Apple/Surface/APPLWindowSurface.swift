//
//  File.swift
//
//
//  Created by Christian Treffs on 12.06.23.
//

#if FRB_PLATFORM_APPL
public protocol APPLWindowSurface: WindowSurfaceBase { }

#if FRB_GRAPHICS_METAL
public typealias MTLWindowSurface = APPLMTLWindowSurface
#endif

#endif


