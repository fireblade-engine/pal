//
// PointerButton.swift
// Fireblade PAL
//
// Copyright © 2018-2021 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

public enum PointerButton {
    case left, middle, right
    case other(_ buttonNumber: Int)
}

extension PointerButton: Equatable {}
