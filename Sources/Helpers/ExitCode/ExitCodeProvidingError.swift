// ExitCodeProvidingError.swift, 19.01.2023-12.03.2023.
// Copyright © 2023 Stanislav Lomachinskiy.

import Foundation

/// A specialized error that provides an exit code.
///
/// Exit code must conform to ``ExitCodeProtocol``.
///
/// An example of a hypothetical enumeration extension:
///
/// ```swift
/// extension AppError: ExitCodeProvidingError {
///     var code: ExitCode {
///         switch self {
///         case .noArguments:
///             return .wrongUsage
///         default:
///             return .failure
///         }
///     }
/// }
/// ```
public protocol ExitCodeProvidingError: Error {

	associatedtype ExitCode: ExitCodeProtocol

	/// The exit code.
	var exitCode: ExitCode { get }

}
