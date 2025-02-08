// URL+FilenameComponents.swift, 25.12.2024.
// Copyright © 2024 Stanislav Lomachinskiy.

import Foundation
import System

@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, visionOS 1.0, watchOS 9.0, *)
public extension URL {

	/// Filename components.
	///
	/// URL must have a non-directory reference. Otherwise, `nil` is returned.
	var filenameComponents: FilenameComponents? {
		let filePath = FilePath(lastPathComponent)
		guard let stem = filePath.stem else {
			return nil
		}
		let directoryURL = deletingLastPathComponent()

		return FilenameComponents(
			directoryURL: directoryURL,
			stem: stem,
			extension: filePath.extension,
			isDirectory: hasDirectoryPath
		)
	}

}
