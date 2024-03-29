//
// Events.swift
// Fireblade PAL
//
// Copyright © 2018-2023 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

import FirebladeMath
import FirebladeTime

public enum Events {
    private static var platform: PlatformEvents = {
        switch Platform.implementation {
        #if FRB_PLATFORM_SDL
            case .sdl:
                return SDLEvents()
        #endif

        #if FRB_PLATFORM_APPL
            case .apple:
                return APPLEvents()
        #endif
        }
    }()

    /// Pump the event loop, gathering events from the input devices.
    public static func pumpEvents() {
        platform.pumpEvents()
    }

    /// Poll for currently pending events.
    public static func pollEvent(_ event: inout Event) -> Bool {
        platform.pollEvent(&event)
    }
}

// MARK: - Event

public struct Event {
    public var timestamp: Nanoseconds
    public var variant: Variant
    public var window: WindowEvent
    public var keyboard: KeyboardEvent
    public var pointerMotion: PointerMotionEvent
    public var pointerButton: PointerButtonEvent
    public var pointerScroll: PointerScrollEvent
    public var textInput: TextInputEvent
    public var textEditing: TextEditingEvent

    public init(timestamp: Nanoseconds = 0) {
        self.timestamp = timestamp
        variant = .none
        window = WindowEvent()
        keyboard = KeyboardEvent()
        pointerMotion = PointerMotionEvent()
        pointerButton = PointerButtonEvent()
        pointerScroll = PointerScrollEvent()
        textInput = TextInputEvent()
        textEditing = TextEditingEvent()
    }
}

public extension Event {
    enum Variant {
        case none
        case userQuit
        case window
        case keyboard
        case pointerMotion
        case pointerButton
        case pointerScroll
        case textInput
        case textEditing
    }
}

// MARK: - Pointer Motion Event

public struct PointerMotionEvent {
    public var windowID: Int
    public var pointerID: Int

    /// X coordinate, relative to window
    public var x: Float
    /// Y coordinate, relative to window
    public var y: Float

    public var deltaX: Float
    public var deltaY: Float

    init() {
        windowID = -1
        pointerID = -1
        x = 0
        y = 0
        deltaX = 0
        deltaY = 0
    }
}

// MARK: - Pointer Button Event

public struct PointerButtonEvent {
    public var windowID: Int
    public var pointerID: Int
    public var state: SwitchState
    public var button: PointerButton
    public var numTaps: Int

    /// relative to window
    public var x: Float

    /// relative to window
    public var y: Float

    init() {
        windowID = -1
        pointerID = -1
        state = .released
        numTaps = -1
        button = .left
        x = 0
        y = 0
    }
}

// MARK: - Pointer Scroll Event

public struct PointerScrollEvent {
    public var windowID: Int
    public var pointerID: Int

    /// left  == negative values;  right ==  positive values
    public var horizontal: Int

    /// down == negative values; up == positive values
    public var vertical: Int

    /// relative to window
    public var x: Float

    /// relative to window
    public var y: Float

    init() {
        windowID = -1
        pointerID = -1
        horizontal = 0
        vertical = 0
        x = 0
        y = 0
    }
}

// MARK: - Window Events

public struct WindowEvent {
    public var windowID: Int
    public var action: WindowEvent.Event

    init() {
        action = .closeRequested
        windowID = -1
    }
}

public extension WindowEvent {
    enum Event {
        /// Window has been shown
        case shown

        /// Window has been hidden
        case hidden

        /// Window needs redraw
        case needsRedraw

        /// Window has been moved to given position.
        case movedTo(position: Point<Int>)

        case sizeChangedTo(size: Size<Int>)

        /// Window has been resized to given size.
        case resizedTo(size: Size<Int>)

        /// Window has been minimized
        case minimized

        /// Window has been maximized
        case maximized

        /// Window has been restored to normal size and position
        case restored

        case pointerFocusGained
        case pointerFocusLost

        case keyboardFocusGained
        case keyboardFocusLost

        /// The window manager requested that the window be closed.
        case closeRequested

        case takeInputFocus

        case screenChangedTo(screen: Screen)
    }
}

// MARK: - Keyboard Event

public struct KeyboardEvent {
    public var windowID: Int
    public var state: SwitchState
    public var isRepeat: Bool
    /// keyboard dependent key code
    public var virtualKey: KeyCode?
    /// aka scan code - independent of keyboard layout
    public var physicalKey: KeyCode

    public var modifiers: KeyModifier

    init() {
        windowID = -1
        state = .released
        isRepeat = false
        virtualKey = nil
        physicalKey = .END
        modifiers = .none
    }
}

public enum SwitchState {
    case pressed
    case released
}

// MARK: - TextInput Event

public struct TextInputEvent {
    public var windowID: Int
    public var text: String

    init() {
        windowID = -1
        text = ""
    }
}

// MARK: - TextEditing Event

public struct TextEditingEvent {
    public var windowID: Int
    public var text: String
    public var start: Int
    public var length: Int

    init() {
        windowID = -1
        text = ""
        start = -1
        length = -1
    }
}
