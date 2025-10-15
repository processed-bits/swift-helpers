// exit.swift, 15.01.2023.
// Copyright © 2023 Stanislav Lomachinskiy.

import Foundation

/// Exits with an exit code.
///
/// Exit code must conform to ``ExitCodeProtocol``.
///
/// When throwing errors, that should stop the program execution, the convenient way is to pass an error, that conforms to the ``ExitCodeProvidingError`` protocol, as an argument to the corresponding ``exit(_:)-1qxrq`` helper function.
public func exit(_ code: any ExitCodeProtocol) -> Never {
	Foundation.exit(code.rawValue)
}

/// Exits with an error.
///
/// If the error conforms to the ``ExitCodeProvidingError`` protocol, its exit code it used. Otherwise, failure exit code value is used (`1`).
public func exit(_ error: any Error) -> Never {
	switch error {
	case let error as any ExitCodeProvidingError:
		exit(error.exitCode)
	default:
		exit(EXIT_FAILURE)
	}
}
