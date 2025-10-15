// String+Logging.swift, 21.02.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

public extension String {

	/// Returns a string reference to a location in source code.
	///
	/// The string comprises the name of the module and the file, the line number and the name of the declaration in which it appears:
	///
	/// ```
	/// HelpersTests/LoggerTests.swift:19 [testPoint()]
	/// ```
	@inlinable static func filePoint(
		file: StaticString = #fileID,
		line: UInt = #line,
		function: String = #function
	) -> String {
		"\(file):\(line) [\(function)]"
	}

}
