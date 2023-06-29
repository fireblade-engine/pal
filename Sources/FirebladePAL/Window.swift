//
// Window.swift
// Fireblade PAL
//
// Copyright © 2018-2023 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

import FirebladeMath
@_implementationOnly import NFD

#if FRB_PLATFORM_SDL
    public typealias Window = SDLWindow
#elseif FRB_PLATFORM_APPL
    public typealias Window = APPLWindow
#endif

public protocol WindowBase: AnyObject {
    typealias SurfaceConstructor<Surface> = (Window) throws -> Surface where Surface: WindowSurface

    /// Creates a window using given properties and surface constructor.
    /// - Parameters:
    ///   - properties: Window properties.
    ///   - surface: Window surface constructor to be used.
    ///              Surface type not be changed after window creation.
    init<Surface>(properties: WindowProperties, surface surfaceConstructor: @escaping SurfaceConstructor<Surface>) throws

    /// Creates a window using given properties and prepares
    /// the window for deferred surface creation using given surface type.
    /// - Parameters:
    ///   - properties: Window properties.
    ///   - surfaceType: The window surface type preparing the window for deferred surface creation.
    ///                  Override `createSurface(of:, in:)` to control deferred surface creation.
    ///                  Surface type not be changed after window creation.
    init(properties: WindowProperties, surfaceType: WindowSurface.Type) throws

    var windowID: Int { get }
    var title: String? { get set }
    var frame: Rect<Int> { get set }

    var fullscreen: Bool { get set }

    var screen: Screen? { get }

    static func createSurface(of surfaceType: WindowSurface.Type, in window: Window) throws -> WindowSurface
    var surfaceType: WindowSurface.Type { get }
    var surface: WindowSurface? { get }

    func close()
    func centerOnScreen()
}

// MARK: - Dialogs

public extension WindowBase {
    /// Single file open dialog
    /// - Parameters:
    ///   - startPath: The current directory shown in the dialog.
    ///   - fileExtensions: An array of filename extensions or UTIs that represent the allowed file types for the dialog.
    /// - Returns: Selected file path or `nil` if user canceled.
    static func openDialog(at startPath: String? = nil, filterFor fileExtensions: [String]? = nil) throws -> String? {
        switch NFD.OpenDialog(filter: fileExtensions, defaultPath: startPath) {
        case let .success(path):
            return path
        case let .failure(error):
            throw error
        }
    }

    /// Multiple file open dialog
    /// - Parameters:
    ///   - startPath: The current directory shown in the dialog.
    ///   - fileExtensions: An array of filename extensions or UTIs that represent the allowed file types for the dialog.
    /// - Returns: Array of selected file paths or `nil` if user canceled.
    static func openDialogMultiple(at startPath: String? = nil, filterFor fileExtensions: [String]? = nil) throws -> [String]? {
        switch NFD.OpenDialogMultiple(filter: fileExtensions, defaultPath: startPath) {
        case let .success(path):
            return path
        case let .failure(error):
            throw error
        }
    }

    /// Save dialog
    /// - Parameters:
    ///   - startPath: The current directory shown in the dialog.
    ///   - fileExtensions: An array of filename extensions or UTIs that represent the allowed file types for the dialog.
    /// - Returns: Selected file path or `nil` if user canceled.
    static func saveDialog(at startPath: String? = nil, filterFor fileExtensions: [String]? = nil) throws -> String? {
        switch NFD.SaveDialog(filter: fileExtensions, defaultPath: startPath) {
        case let .success(path):
            return path
        case let .failure(error):
            throw error
        }
    }

    /// Select folder dialog
    /// - Parameter startPath: The current directory shown in the dialog.
    /// - Returns: Selected folder path or `nil` if user canceled.
    static func pickFolder(at startPath: String? = nil) throws -> String? {
        switch NFD.PickFolder(defaultPath: startPath) {
        case let .success(path):
            return path
        case let .failure(error):
            throw error
        }
    }
}

// MARK: - Window properties

public struct WindowProperties {
    public var title: String
    public var frame: Rect<Int>

    public init(title: String, frame: Rect<Int>) {
        self.title = title
        self.frame = frame
    }
}

public extension Point where Value == Int {
    static let centerOnScreen = Point(x: -1, y: -1)
}
