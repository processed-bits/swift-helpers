// URL+HomeDirectory.swift, 05.04.2024.
// Copyright © 2024 Stanislav Lomachinskiy.

import Foundation

public extension URL {

	/// Returns a URL made by expanding the home directory component of the receiver (“~”) to its full path value.
	///
	/// Home directory expansion usually occurs in shell. This property is helpful if:
	///
	/// - you are passing arguments in an Xcode scheme;
	/// - you want expansion to occur even inside quoted strings.
	///
	/// If `self` is not a file URL, or has no or multiple home directory components, returns `self`.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	var expandingTildeInPath: URL {
		guard isFileURL, let index = pathComponents.firstIndex(of: "~"), index == pathComponents.lastIndex(of: "~") else {
			return self
		}

		let nextIndex = pathComponents.index(after: index)
		let homeURL = URL.homeDirectory
		guard nextIndex < pathComponents.endIndex else {
			return homeURL
		}

		let components = pathComponents[nextIndex ..< pathComponents.endIndex]
		let appendedPath = components.joined(separator: "/")
		let directoryHint: URL.DirectoryHint = hasDirectoryPath ? .isDirectory : .notDirectory
		return homeURL.appending(path: appendedPath, directoryHint: directoryHint)
	}

}
