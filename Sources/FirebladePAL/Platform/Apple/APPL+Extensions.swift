//
// APPL+Extensions.swift
// Fireblade PAL
//
// Copyright © 2018-2021 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

#if FRB_PLATFORM_APPL

    #if FRB_PLATFORM_APPL_MACOS || FRB_PLATFORM_APPL_IOS
        import struct CoreGraphics.CGFloat
        import struct CoreGraphics.CGPoint
        import struct CoreGraphics.CGRect
        import struct CoreGraphics.CGSize

        import FirebladeMath

        extension Rect where Value: BinaryFloatingPoint {
            init(origin: CGPoint, size: CGSize) {
                self.init(origin: Point(point: origin),
                          size: Size(size: size))
            }

            init(rect: CGRect) {
                self.init(origin: rect.origin, size: rect.size)
            }
        }

        extension Size where Value: BinaryFloatingPoint {
            init(size: CGSize) {
                self.init(width: Value(size.width),
                          height: Value(size.height))
            }
        }

        extension Point where Value: BinaryFloatingPoint {
            init(point: CGPoint) {
                self.init(x: Value(point.x),
                          y: Value(point.y))
            }
        }

        extension CGRect {
            init<V>(rect: Rect<V>) where V: BinaryFloatingPoint {
                self.init(origin: CGPoint(point: rect.origin),
                          size: CGSize(size: rect.size))
            }
        }

        extension CGSize {
            init<V>(size: Size<V>) where V: BinaryFloatingPoint {
                self.init(width: CGFloat(size.width),
                          height: CGFloat(size.height))
            }
        }

        extension CGPoint {
            init<V>(point: Point<V>) where V: BinaryFloatingPoint {
                self.init(x: CGFloat(point.x),
                          y: CGFloat(point.y))
            }
        }
    #endif

#endif
