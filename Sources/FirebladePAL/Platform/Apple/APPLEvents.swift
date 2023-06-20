//
// APPLEvents.swift
// Fireblade PAL
//
// Copyright © 2018-2023 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

#if FRB_PLATFORM_APPL

    #if canImport(AppKit)
        import AppKit
    #endif

    struct APPLEvents: PlatformEvents {
        func pushEvent(_: Event) {
            #warning("❗TODO: implement")
        }

        func pumpEvents() {
            autoreleasepool {
                appKitPumpEvents(until: .distantFuture)
            }
        }

        func pollEvent(_: inout Event) -> Bool {
            #warning("❗TODO: implement")
            return false
        }

        // https://github.com/libsdl-org/SDL/blob/dec0dbff13d4091035209016eb2d0dd82c9aba58/src/video/cocoa/SDL_cocoaevents.m#LL527C5-L527C30
        private func appKitPumpEvents(until expiration: Date?) {
            while true {
                guard let event = NSApp.nextEvent(matching: .any, until: expiration, inMode: .default, dequeue: true) else {
                    return
                }

                guard !appKitDispatchEvent(event) else {
                    return
                }

                NSApp.sendEvent(event)
            }
        }

        private func appKitDispatchEvent(_ nsEvent: NSEvent) -> Bool {
            print(nsEvent)
            var event = Event()
            Self.translate(from: nsEvent, to: &event)
            return false
        }

        private static func translate(from nsEvent: NSEvent, to event: inout Event) {
            event.variant = .none
            switch nsEvent.type {
            case .keyDown,
                 .keyUp,
                 .flagsChanged:
                event.variant = .keyboard
                translateKeyboardEvent(from: nsEvent, to: &event.keyboard)

            case .leftMouseDown,
                 .leftMouseUp,
                 .rightMouseDown,
                 .rightMouseUp,
                 .mouseMoved,
                 .leftMouseDragged,
                 .rightMouseDragged,
                 .otherMouseDown,
                 .otherMouseUp,
                 .otherMouseDragged,
                 .scrollWheel:
                break

            default:
                break
            }
        }

        private static func translateKeyboardEvent(from nsEvent: NSEvent, to _: inout KeyboardEvent) {
            print(nsEvent)
        }
    }

#endif
