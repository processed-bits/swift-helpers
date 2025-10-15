// Logger+ExtendedLogger.swift, 11.01.2021.
// Copyright © 2021-2025 Stanislav Lomachinskiy.

#if canImport(os.log)
	import os

	@available(iOS 14.0, macOS 11.0, macCatalyst 14.0, tvOS 14.0, watchOS 7.0, *)
	extension Logger: ExtendedLogger {

		// MARK: Logging a Source Code Reference

		public func point(
			file: StaticString = #fileID,
			line: UInt = #line,
			function: String = #function
		) {
			let point = String.filePoint(file: file, line: line, function: function)
			debug("\(point, privacy: .public)")
		}

	}
#endif
