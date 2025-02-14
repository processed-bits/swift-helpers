// LegacyLogger+ExtendedLogger.swift, 11.01.2021-12.02.2025.
// Copyright © 2021-2025 Stanislav Lomachinskiy.

extension LegacyLogger: ExtendedLogger {

	public nonisolated(unsafe) static let `default` = Self()

	// MARK: Logging a Point

	public func point(fileID: String = #fileID, line: UInt = #line, function: String = #function) {
		let sourceLocation = Self.sourceLocation(fileID: fileID, line: line, function: function)
		debug("\(sourceLocation)")
	}

}
