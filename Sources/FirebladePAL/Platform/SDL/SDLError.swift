//
// SDLError.swift
// Fireblade PAL
//
// Copyright © 2018-2023 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

#if FRB_PLATFORM_SDL

    @_implementationOnly import SDL

    public struct SDLError: Swift.Error {
        let reason: String
        var localizedDescription: String { reason }

        init?(code: SDL_errorcode) {
            guard let cString = UnsafePointer<CChar>(bitPattern: Int(SDL_Error(code))) else {
                return nil
            }
            reason = String(cString: cString)
        }

        public init() {
            if let cString = SDL_GetError() {
                reason = String(cString: cString)
            } else {
                reason = "?"
            }

            SDL_ClearError()
        }
    }

    extension SDLError: CustomStringConvertible {
        public var description: String {
            reason
        }
    }

    extension SDLError: CustomDebugStringConvertible {
        public var debugDescription: String {
            reason
        }
    }

    func SDLAssert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line) {
        assert(condition(), SDLError().reason + " \(message())", file: file, line: line)
    }

#endif
