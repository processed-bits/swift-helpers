// ExtendedLogger.swift, 11.02.2023.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

public protocol ExtendedLogger {

	// MARK: Logging a Source Code Reference

	/// Writes a debug message to the log referencing a location in source code.
	///
	/// The string comprises the name of the module and the file, the line number and the name of the declaration in which it appears:
	///
	/// ```
	/// HelpersTests/LoggerTests.swift:19 [testPoint()]
	/// ```
	func point(
		file: StaticString,
		line: UInt,
		function: String
	)

}
