// FilenameComponents.swift, 25.12.2024.
// Copyright © 2024 Stanislav Lomachinskiy.

import Foundation

/// A type that represents filename components.
///
/// This type is intended for filename manipulation using its mutable components: containing directory, stem, and extension. Directory flag is immutable.
@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
public struct FilenameComponents: Equatable {
	/// The containing directory of the file.
	public var directoryURL: URL
	/// The non-extension portion of the file or directory last component.
	public var stem: String
	/// The extension of the file or directory last component.
	public var `extension`: String?
	/// A Boolean that is true if the filename represents a directory.
	public let isDirectory: Bool

	// MARK: Life Cycle

	/// Creates a filename components structure.
	public init(directoryURL: URL, stem: String, extension: String?, isDirectory: Bool) {
		self.directoryURL = directoryURL
		self.stem = stem
		self.extension = `extension`
		self.isDirectory = isDirectory
	}

	// MARK: Getting the URL

	/// A URL derived from the components.
	public var url: URL {
		var filename = stem
		if let `extension` {
			filename += ".\(`extension`)"
		}
		return directoryURL.appending(
			component: filename,
			directoryHint: isDirectory ? .isDirectory : .notDirectory
		)
	}
}
