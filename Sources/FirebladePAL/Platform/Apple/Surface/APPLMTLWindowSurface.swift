//
//  File.swift
//  
//
//  Created by Christian Treffs on 12.06.23.
//

#if FRB_PLATFORM_APPL && FRB_GRAPHICS_METAL

import func Metal.MTLCreateSystemDefaultDevice
import protocol Metal.MTLDevice
import class QuartzCore.CAMetalLayer
import class QuartzCore.CALayer
import class Foundation.NSCoder
import FirebladeMath


open class APPLMTLWindowSurface: APPLView, MTLWindowSurfaceBase {
    public required init(in window: Window, device: MTLDevice?) throws {
        fatalError()
    }
    
    required public init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func create(in window: Window) throws -> Self {
        fatalError()
    }
    
    public var enableVsync: Bool {
        get {
            #if os(macOS)
            return self.mtlLayer!.displaySyncEnabled
            #else
            return false
            #endif
        }
        set {
            #if os(macOS)
            self.mtlLayer!.displaySyncEnabled = newValue
            #endif
        }
    }

    public var mtlLayer: CAMetalLayer? {
        fatalError()
    }

    public func destroy() {
        fatalError()
    }
    
    public func getDrawableSize() -> Size<Int> {
        fatalError()
    }
    

}


#endif
