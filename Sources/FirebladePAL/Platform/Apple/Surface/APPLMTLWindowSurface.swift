//
// APPLMTLWindowSurface.swift
// Fireblade PAL
//
// Copyright © 2018-2023 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

#if FRB_PLATFORM_APPL && FRB_GRAPHICS_METAL

    import FirebladeMath
    import class Foundation.NSCoder
    import func Metal.MTLCreateSystemDefaultDevice
    import protocol Metal.MTLDevice
    import class QuartzCore.CALayer
    import class QuartzCore.CAMetalLayer

    open class APPLMTLWindowSurface: APPLView, MTLWindowSurfaceBase {
        public required init(in _: Window, device _: MTLDevice?) throws {
            fatalError()
        }

        @available(*, unavailable)
        public required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public static func create(in _: Window) throws -> Self {
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
