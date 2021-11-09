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

extension PointerButton: RawRepresentable {
    @_transparent
    public var index: Int { rawValue }

    @inlinable
    public init?(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .left
        case 1:
            self = .middle
        case 2:
            self = .right
        default:
            self = .other(rawValue)
        }
    }

    @inlinable
    public var rawValue: Int {
        switch self {
        case .left: return 0
        case .middle: return 1
        case .right: return 2
        case let .other(nr):
            return nr
        }
    }
}
