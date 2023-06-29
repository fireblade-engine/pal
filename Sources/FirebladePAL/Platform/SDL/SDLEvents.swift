//
// SDLEvents.swift
// Fireblade PAL
//
// Copyright © 2018-2023 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

#if FRB_PLATFORM_SDL

    import FirebladeMath
    import FirebladeTime
    @_implementationOnly import SDL

    final class SDLEvents: PlatformEvents {
        private var _event = SDL_Event()

        func pumpEvents() {
            SDL_PumpEvents()
        }

        func pollEvent(_ event: inout Event) -> Bool {
            let hasPending = SDL_PollEvent(&_event)
            Self.translate(from: _event, to: &event)
            return hasPending == 1
        }

        private static func translate(from sdlEvent: SDL_Event, to event: inout Event) {
            let sdlEventType = SDL_EventType(sdlEvent.type)
            event.variant = .none
            switch sdlEventType {
            case SDL_QUIT:
                event.variant = .userQuit

            case SDL_KEYDOWN,
                 SDL_KEYUP:
                event.variant = .keyboard
                translateKeyboardEvent(from: sdlEvent.key, to: &event.keyboard)

            case SDL_MOUSEMOTION:
                event.variant = .pointerMotion
                translateMouseMotionEvent(from: sdlEvent.motion, to: &event.pointerMotion)

            case SDL_MOUSEBUTTONDOWN,
                 SDL_MOUSEBUTTONUP:
                event.variant = .pointerButton
                translateMouseButtonEvent(from: sdlEvent.button, to: &event.pointerButton)

            case SDL_MOUSEWHEEL:
                event.variant = .pointerScroll
                translateMouseWheelEvent(from: sdlEvent.wheel, to: &event.pointerScroll)

            case SDL_WINDOWEVENT:
                if translateWindowEvent(from: sdlEvent.window, to: &event.window) {
                    event.variant = .window
                }

            case SDL_TEXTINPUT:
                event.variant = .textInput
                translateTextInputEvent(from: sdlEvent.text, to: &event.textInput)

            case SDL_TEXTEDITING:
                event.variant = .textEditing
                translateTextEditingEvent(from: sdlEvent.edit, to: &event.textEditing)

            default:
                break
            }
        }

        private static func translateMouseMotionEvent(from sdlEvent: SDL_MouseMotionEvent, to event: inout PointerMotionEvent) {
            event.windowID = Int(sdlEvent.windowID)
            event.pointerID = Int(sdlEvent.which)
            event.x = Float(sdlEvent.x)
            event.y = Float(sdlEvent.y)
            event.deltaX = Float(sdlEvent.xrel)
            event.deltaY = Float(sdlEvent.yrel)
        }

        private static func translateMouseButtonEvent(from sdlEvent: SDL_MouseButtonEvent, to event: inout PointerButtonEvent) {
            event.windowID = Int(sdlEvent.windowID)
            event.pointerID = Int(sdlEvent.which)
            if let mappedButton = pointerButtonMap[Int32(sdlEvent.button)] {
                event.button = mappedButton
            } else {
                print("warning: could not map sdl mouse button \(sdlEvent.button)")
                return
            }
            event.numTaps = Int(sdlEvent.clicks)

            switch Int32(sdlEvent.state) {
            case SDL_PRESSED:
                event.state = .pressed
            case SDL_RELEASED:
                event.state = .released
            default:
                assertionFailure("Unexpected state \(sdlEvent.state)")
            }

            event.x = Float(sdlEvent.x)
            event.y = Float(sdlEvent.y)
        }

        private static func translateMouseWheelEvent(from sdlEvent: SDL_MouseWheelEvent, to event: inout PointerScrollEvent) {
            event.windowID = Int(sdlEvent.windowID)
            event.pointerID = Int(sdlEvent.which)

            let sign: Int
            switch SDL_MouseWheelDirection(sdlEvent.direction) {
            case SDL_MOUSEWHEEL_NORMAL:
                sign = 1
            case SDL_MOUSEWHEEL_FLIPPED:
                sign = -1
            default:
                assertionFailure("Unexpected mouse wheel direction \(sdlEvent.direction)")
                sign = 0
            }

            //  left  == negative x values;  right ==  positive x values
            event.horizontal = sign * Int(sdlEvent.x)

            // down/backward == negative y values; up/forward == positive y values
            event.vertical = sign * Int(sdlEvent.y)

            event.x = Float(sdlEvent.x)
            event.y = Float(sdlEvent.y)
        }

        private static func translateWindowEvent(from sdlEvent: SDL_WindowEvent, to event: inout WindowEvent) -> Bool {
            event.windowID = Int(sdlEvent.windowID)

            switch SDL_WindowEventID(UInt32(sdlEvent.event)) {
            case SDL_WINDOWEVENT_RESIZED:
                event.action = .resizedTo(size: .init(width: Int(sdlEvent.data1), height: Int(sdlEvent.data1)))
                return true

            case SDL_WINDOWEVENT_CLOSE:
                event.action = .closeRequested
                return true

            default:
                // TODO: translate all window events
                return false
            }
        }

        private static func translateKeyboardEvent(from sdlEvent: SDL_KeyboardEvent, to event: inout KeyboardEvent) {
            event.windowID = Int(sdlEvent.windowID)

            switch Int32(sdlEvent.state) {
            case SDL_PRESSED:
                event.state = .pressed
            case SDL_RELEASED:
                event.state = .released
            default:
                assertionFailure("Unexpected state \(sdlEvent.state)")
            }

            event.isRepeat = (sdlEvent.repeat != 0)

            // SDL virtual key code; see SDL_Keycode for details
            event.virtualKey = KeyCode.virtualKeyMap[SDL_KeyCode(UInt32(sdlEvent.keysym.sym))]

            // SDL physical key code; see SDL_Scancode for details
            event.physicalKey = KeyCode.physicalKeyMap[sdlEvent.keysym.scancode]!

            // current key modifiers; see SDL_Keymod for details
            translateKeyboardModifiers(sdlModifiers: SDL_Keymod(UInt32(sdlEvent.keysym.mod)), modifiers: &event.modifiers)
        }

        private static func translateKeyboardModifiers(sdlModifiers: SDL_Keymod, modifiers: inout KeyModifier) {
            modifiers = .none

            if sdlModifiers.contains(KMOD_LSHIFT) {
                modifiers.insert(.shiftLeft)
            }
            if sdlModifiers.contains(KMOD_RSHIFT) {
                modifiers.insert(.shiftRight)
            }
            if sdlModifiers.contains(KMOD_LCTRL) {
                modifiers.insert(.controlLeft)
            }
            if sdlModifiers.contains(KMOD_RCTRL) {
                modifiers.insert(.controlRight)
            }
            if sdlModifiers.contains(KMOD_LALT) {
                modifiers.insert(.alternateLeft)
            }
            if sdlModifiers.contains(KMOD_RALT) {
                modifiers.insert(.alternateRight)
            }
            if sdlModifiers.contains(KMOD_LGUI) {
                modifiers.insert(.metaLeft)
            }
            if sdlModifiers.contains(KMOD_RGUI) {
                modifiers.insert(.metaRight)
            }
            if sdlModifiers.contains(KMOD_MODE) {
                modifiers.insert(.alternateGraphic)
            }
            if sdlModifiers.contains(KMOD_CAPS) {
                modifiers.insert(.capsLock)
            }
            if sdlModifiers.contains(KMOD_NUM) {
                modifiers.insert(.numLock)
            }
        }

        private static func translateTextInputEvent(from sdlEvent: SDL_TextInputEvent, to event: inout TextInputEvent) {
            event.windowID = Int(sdlEvent.windowID)
            event.text = withUnsafePointer(to: sdlEvent.text) {
                $0.withMemoryRebound(to: UInt8.self, capacity: 32) {
                    String(cString: $0)
                }
            }
        }

        private static func translateTextEditingEvent(from sdlEvent: SDL_TextEditingEvent, to event: inout TextEditingEvent) {
            event.windowID = Int(sdlEvent.windowID)
            event.text = withUnsafePointer(to: sdlEvent.text) {
                $0.withMemoryRebound(to: UInt8.self, capacity: 32) {
                    String(cString: $0)
                }
            }
            event.start = Int(sdlEvent.start)
            event.length = Int(sdlEvent.length)
        }

        static let pointerButtonMap: [Int32: PointerButton] = [
            SDL_BUTTON_LEFT: .left,
            SDL_BUTTON_MIDDLE: .middle,
            SDL_BUTTON_RIGHT: .right,
            SDL_BUTTON_X1: .other(4), // extra button 1 is mouse button 4
            SDL_BUTTON_X2: .other(5), // extra button 2 is mouse button 5
        ]
    }

    extension SDL_Scancode: Equatable {}
    extension SDL_Scancode: Hashable {}

    extension SDL_Keymod {
        func contains(_ mod: SDL_Keymod) -> Bool {
            rawValue & mod.rawValue != 0
        }
    }
#endif
