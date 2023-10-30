// ExitCodeProtocol.swift, 18.01.2023-12.03.2023.
// Copyright © 2023 Stanislav Lomachinskiy.

import Foundation

/// A type that represents an exit code with an `Int32` raw value.
///
/// ```swift
/// enum ExitCode: Int32, ExitCodeProtocol {
///	    case success = 0
///	    case failure = 1
///	}
/// ```
public protocol ExitCodeProtocol: RawRepresentable<Int32> {}
