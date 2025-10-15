// LegacyLogger+ExtendedLogger.swift, 11.01.2021.
// Copyright © 2021-2025 Stanislav Lomachinskiy.

#if canImport(os.log)
	extension LegacyLogger: ExtendedLogger {

		// MARK: Logging a Source Code Reference

		public func point(
			file: StaticString = #fileID,
			line: UInt = #line,
			function: String = #function
		) {
			let point = String.filePoint(file: file, line: line, function: function)
			debug("\(point)")
		}

	}
#endif
