//
// APPLView.swift
// Fireblade PAL
//
// Copyright © 2018-2021 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

#if FRB_PLATFORM_APPL

import FirebladeMath

#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif

public typealias NativeView = _APPLView

open class APPLView: _APPLView {
    var nativeView: NativeView { self }

    override init(frame: CGRect) {
        super.init(frame: frame)

#if os(macOS) && !targetEnvironment(macCatalyst)
        wantsLayer = true
        layerContentsRedrawPolicy = .duringViewResize
        layer?.backgroundColor = CGColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
#else
        backgroundColor = .red
#endif
    }

    /*
     override func makeBackingLayer() -> CALayer {
     CAMetalLayer.init()
     }
     */

    required public init?(coder _: NSCoder) { nil }
    
    var rect: Rect<Float> {
        get { Rect(rect: frame) }
        set {
#if os(macOS) && !targetEnvironment(macCatalyst)
            frame = .init(rect: newValue)
#endif
        }
    }

#if os(macOS) && !targetEnvironment(macCatalyst)
    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
    }

    open override func viewWillMove(toWindow newWindow: _APPLWindow?) {
        super.viewWillMove(toWindow: newWindow)
    }
#else

    open override func willMove(toWindow newWindow: _APPLWindow?) {
        super.willMove(toWindow: newWindow)
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
    }

#endif
}

#endif
