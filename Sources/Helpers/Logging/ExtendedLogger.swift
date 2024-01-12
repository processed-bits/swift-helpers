// ExtendedLogger.swift, 11.02.2023-04.05.2023.
// Copyright © 2023 Stanislav Lomachinskiy.

import Foundation

public protocol ExtendedLogger {

	/// A logger that writes to the default subsystem.
	static var `default`: Self { get }

	// MARK: Logging a Point

	/// Writes a debug reference to a point in source code to the log.
	func point(fileID: String, line: UInt, function: String)

	/// Returns a string reference to a point in source code.
	///
	/// The default implementation returns a string consisting of the name of the module and file, the line number and the name of the declaration:
	///
	/// ```
	/// HelpersTests/LoggerTests.swift:21 [testPoint()]
	/// ```
	///
	/// The returned string is used in implementations of ``point(fileID:line:function:)``.
	static func sourceLocation(fileID: String, line: UInt, function: String) -> String

}

public extension ExtendedLogger {

	@inlinable static func sourceLocation(fileID: String = #fileID, line: UInt = #line, function: String = #function) -> String {
		"\(fileID):\(line) [\(function)]"
	}

}
