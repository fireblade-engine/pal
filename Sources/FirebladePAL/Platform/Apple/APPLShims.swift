//
// APPLShims.swift
// Fireblade Engine
//
// Copyright © 2018-2021 Fireblade Team. All rights reserved.
// Licensed under GNU General Public License v3.0. See LICENSE file for details.

#if FRB_PLATFORM_APPL

#if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
import class AppKit.NSApplication
import protocol AppKit.NSApplicationDelegate
import class AppKit.NSEvent
import class AppKit.NSScreen
import class AppKit.NSView
import class AppKit.NSViewController
import class AppKit.NSWindow
import class CoreVideo.CVDisplayLink

typealias _APPLDisplayLink = CVDisplayLink
typealias _APPLScreen = NSScreen
typealias _APPLAppDelegate = NSApplicationDelegate
typealias _APPLApplication = NSApplication
typealias _APPLEvent = NSEvent
public typealias _APPLWindow = NSWindow
public typealias _APPLViewController = NSViewController
public typealias _APPLView = NSView

#elseif FRB_PLATFORM_APPL_IOS || targetEnvironment(macCatalyst)

// MARK: - UIKit

import class QuartzCore.CADisplayLink
import class UIKit.UIApplication
import protocol UIKit.UIApplicationDelegate
import class UIKit.UIEvent
import class UIKit.UIScreen
import class UIKit.UIView
import class UIKit.UIViewController
import class UIKit.UIWindow

typealias _APPLDisplayLink = CADisplayLink
typealias _APPLScreen = UIScreen
typealias _APPLAppDelegate = UIApplicationDelegate
typealias _APPLApplication = UIApplication
typealias _APPLEvent = UIEvent
public typealias _APPLWindow = UIWindow
public typealias _APPLViewController = UIViewController
public typealias _APPLView = UIView

#endif

#endif
