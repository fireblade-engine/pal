//
// SDLClipboard.swift
// Fireblade PAL
//
// Copyright © 2018-2023 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

#if FRB_PLATFORM_SDL

    @_implementationOnly import SDL

    public struct SDLClipboard: Clipboard {
        public func getText() throws -> String {
            guard let pText = SDL_GetClipboardText() else {
                throw SDLError()
            }
            defer { SDL_free(pText) }
            return String(cString: pText)
        }

        public func setText(_ text: String) throws {
            if SDL_SetClipboardText(text) < 0 {
                throw SDLError()
            }
        }

        public func hasText() -> Bool {
            SDL_HasClipboardText() == SDL_TRUE
        }
    }

#endif
