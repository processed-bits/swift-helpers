// FilenameComponents+Testing.swift, 25.12.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation
import FoundationHelpers
import Testing

@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
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
