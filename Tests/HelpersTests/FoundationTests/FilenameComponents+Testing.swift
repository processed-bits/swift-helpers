// FilenameComponents+Testing.swift, 25.12.2024.
// Copyright © 2024 Stanislav Lomachinskiy.

import Foundation
import Helpers
import Testing

extension FilenameComponents {
	init(directoryString: String, _ stem: String, _ extension: String? = nil, isDirectory: Bool = false) throws {
		let directoryURL = try URL(requireString: directoryString)
		self.init(directoryURL: directoryURL, stem: stem, extension: `extension`, isDirectory: isDirectory)
	}

	init(directoryFilePath: String, _ stem: String, _ extension: String? = nil, isDirectory: Bool = false) {
		let directoryURL = URL(filePath: directoryFilePath)
		self.init(directoryURL: directoryURL, stem: stem, extension: `extension`, isDirectory: isDirectory)
	}
}
