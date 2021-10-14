//
// APPLView.swift
// Fireblade Engine
//
// Copyright © 2018-2021 Fireblade Team. All rights reserved.
// Licensed under GNU General Public License v3.0. See LICENSE file for details.

#if FRB_PLATFORM_APPL

#if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
import AppKit
#elseif FRB_PLATFORM_APPL_IOS || targetEnvironment(macCatalyst)
import UIKit
#endif
import FirebladeMath

public typealias NativeView = _APPLView

class APPLView: _APPLView {
    var nativeView: NativeView { self }

    init() {
        super.init(frame: .zero)

        #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
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

    required init?(coder _: NSCoder) { nil }

    var rect: Rect<Float> {
        get { Rect(rect: frame) }
        set {
            #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
            frame = .init(rect: newValue)
            #endif
        }
    }

    #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
    }

    override func viewWillMove(toWindow newWindow: _APPLWindow?) {
        super.viewWillMove(toWindow: newWindow)
    }
    #else

    override func willMove(toWindow newWindow: _APPLWindow?) {
        super.willMove(toWindow: newWindow)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
    }

    #endif
}

#endif
