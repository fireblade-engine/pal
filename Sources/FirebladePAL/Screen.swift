//
// Screen.swift
// Fireblade PAL
//
// Copyright © 2018-2021 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

import FirebladeMath

#if FRB_PLATFORM_SDL
    public typealias Screen = SDLScreen
#endif

#if FRB_PLATFORM_APPL
    public typealias Screen = APPLScreen
#endif

public protocol ScreenBase: AnyObject {
    var frame: Rect<Int> { get }

    var screenID: Int? { get }

    var refreshRate: Int? { get }

    var name: String? { get }

    static var main: Screen { get }

    static var screens: [Screen] { get }
}

extension Screen: CustomDebugStringConvertible {
    public var debugDescription: String {
        "<Screen id:\(screenID ?? -1) name:\(name ?? "") refreshRate:\(refreshRate ?? -1) scale:\(scale) frame:\(frame)>"
    }
}
