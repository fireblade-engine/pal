//
// Clipboard.swift
// Fireblade PAL
//
// Copyright © 2018-2023 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

public protocol Clipboard {
    /// Get UTF-8 text from the clipboard.
    func getText() throws -> String

    /// Put UTF-8 text into the clipboard.
    func setText(_ text: String) throws

    /// Query whether the clipboard exists and contains a non-empty text string.
    func hasText() -> Bool
}
