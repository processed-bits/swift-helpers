// LegacyLogger+ExtendedLogger.swift, 11.01.2021-23.03.2024.
// Copyright © 2021-2024 Stanislav Lomachinskiy.

extension LegacyLogger: ExtendedLogger {

	public static let `default` = Self()

	// MARK: Logging a Point

	public func point(fileID: String = #fileID, line: UInt = #line, function: String = #function) {
		let sourceLocation = Self.sourceLocation(fileID: fileID, line: line, function: function)
		debug("\(sourceLocation)")
	}

}
