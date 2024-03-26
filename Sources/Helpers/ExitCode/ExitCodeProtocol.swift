// ExitCodeProtocol.swift, 18.01.2023-23.03.2024.
// Copyright © 2023-2024 Stanislav Lomachinskiy.

/// A type that represents an exit code with an `Int32` raw value.
///
/// Usage example:
///
/// ```swift
/// enum ExitCode: Int32, ExitCodeProtocol {
///	    case success = 0
///	    case failure = 1
///	}
/// ```
public protocol ExitCodeProtocol: RawRepresentable<Int32> {}
