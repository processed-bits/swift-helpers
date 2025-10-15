// URL+HomeDirectory.swift, 05.04.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

import Foundation

public extension URL {

	// MARK: Working with File URLs

	/// Returns a URL made by expanding the home directory component (`~`) in the receiver's path to the full path of the user's home directory. If the home directory component contains a username (e.g., `~user`), the specified user's home directory is used.
	///
	/// Expansion only occurs if the URL is a file URL or has no scheme, and does not contain query or fragment components. An expanded URL always has the file scheme.
	///
	/// If expansion is not possible, the original URL is returned.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	var expandingHomeDirectory: URL {
		guard scheme == nil || scheme == "file",
		      host == nil,
		      query(percentEncoded: false) == nil,
		      fragment(percentEncoded: false) == nil else {
			return self
		}

		var inputPath = relativePath
		guard !inputPath.isEmpty, inputPath.removeFirst() == .homeDirectory else {
			return self
		}

		var userName = ""
		var remainingPath = ""
		if let separatorIndex = inputPath.firstIndex(of: .separator) {
			let pathIndex = inputPath.index(separatorIndex, offsetBy: 1)
			userName = String(inputPath.prefix(upTo: separatorIndex))
			remainingPath = String(inputPath.suffix(from: pathIndex))
		} else {
			userName = inputPath
		}

		let homeDirectoryURL: URL
		if !userName.isEmpty {
			guard let url = URL.homeDirectory(forUser: userName) else {
				return self
			}
			homeDirectoryURL = url
		} else {
			homeDirectoryURL = URL.homeDirectory
		}

		var expandedURL = homeDirectoryURL

		if !remainingPath.isEmpty {
			// `relativePath` drops directory indication, recreate it using a directory hint.
			expandedURL.append(
				path: remainingPath,
				directoryHint: hasDirectoryPath ? .isDirectory : .notDirectory
			)
		}

		return expandedURL
	}

}

// MARK: - Private Helpers

private extension Character {
	static let homeDirectory: Self = "~"
	static let separator: Self = "/"
}

// MARK: - Deprecated

public extension URL {
	@available(*, deprecated, renamed: "expandingHomeDirectory")
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	var expandingTildeInPath: URL {
		expandingHomeDirectory
	}
}
