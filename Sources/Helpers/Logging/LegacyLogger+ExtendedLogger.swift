// LegacyLogger+ExtendedLogger.swift, 11.01.2021-01.05.2023.
// Copyright © 2021-2023 Stanislav Lomachinskiy.

import Foundation

extension LegacyLogger: ExtendedLogger {

	public static let `default` = Self()

	// MARK: Logging a Point

	public func point(fileID: String = #fileID, line: UInt = #line, function: String = #function) {
		let sourceLocation = Self.sourceLocation(fileID: fileID, line: line, function: function)
		debug("\(sourceLocation)")
	}

}
