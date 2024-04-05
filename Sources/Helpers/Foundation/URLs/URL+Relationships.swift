// URL+Relationships.swift, 28.02.2024-05.04.2024.
// Copyright © 2024 Stanislav Lomachinskiy.

import Foundation

public extension URL {

	/// Returns a URL made by removing the last path component of self, if the URL represents a file.
	///
	/// If the URL represents a directory, this method returns `self`.
	var directoryURL: URL {
		!hasDirectoryPath ? deletingLastPathComponent() : self
	}

	/// A Boolean that is true if the URL is a relative of another URL.
	///
	/// The URL is considered to be a relative of another URL if both URLs have the same scheme, user, password, host and port components.
	///
	/// See ``isDescendant(of:)`` for more information.
	func isRelative(of otherURL: URL) -> Bool {
		scheme == otherURL.scheme && user == otherURL.user && password == otherURL.password && host == otherURL.host && port == otherURL.port
	}

	/// A Boolean that is true if the URL is a descendant of another URL.
	///
	/// The URL is considered to be a descendant of another URL if:
	///
	///   - the URL is a [relative of another URL](<doc:isRelative(of:)>);
	///   - path components of the URL start with and include all the directory path components of another URL, and have additional components.
	///
	/// See ``isRelative(of:)`` for more information.
	func isDescendant(of otherURL: URL) -> Bool {
		guard isRelative(of: otherURL) else {
			return false
		}

		let parentPathComponents = otherURL.directoryURL.pathComponents
		let startsWithParent = pathComponents.starts(with: parentPathComponents)
		let isLonger = pathComponents.count > parentPathComponents.count
		return startsWithParent && isLonger
	}

	/// Makes the URL relativized to another URL.
	///
	/// - Parameters:
	///   - base: The base URL to which the current URL will be relativized.
	///   - onlyDescending: If `true`, the current URL should descend from the base URL. If `false`, the current URL should be a relative of the base URL. The default is `true`.
	///
	/// If `base` is `nil`, or `self` is not a descendant or a relative of the base URL, this method returns `self`. You may want to standardize your URLs, if they contain any instances of “..” or “.”.
	///
	/// See ``isRelative(of:)`` and ``isDescendant(of:)`` for more information.
	@inlinable mutating func relativize(to base: URL?, onlyDescending: Bool = true) {
		self = relativized(to: base, onlyDescending: onlyDescending)
	}

	/// Returns a URL that is relativized to another URL.
	///
	/// - Parameters:
	///   - base: The base URL to which the current URL will be relativized.
	///   - onlyDescending: If `true`, the current URL should descend from the base URL. If `false`, the current URL should be a relative of the base URL. The default is `true`.
	///
	/// If `base` is `nil`, or `self` is not a descendant or a relative of the base URL, this method returns `self`. You may want to standardize your URLs, if they contain any instances of “..” or “.”.
	///
	/// See ``isRelative(of:)`` and ``isDescendant(of:)`` for more information.
	func relativized(to base: URL?, onlyDescending: Bool = true) -> URL {
		guard let base,
		      onlyDescending ? isDescendant(of: base) : isRelative(of: base) else {
			return self
		}

		let basePathComponents = base.directoryURL.pathComponents

		var commonPathComponentsCount = 0
		for (pathComponent, basePathComponent) in zip(pathComponents, basePathComponents) where pathComponent == basePathComponent {
			commonPathComponentsCount += 1
		}

		var relativePathComponents = Array(repeating: "..", count: basePathComponents.count - commonPathComponentsCount)
		relativePathComponents.append(contentsOf: pathComponents.suffix(from: commonPathComponentsCount))

		var relativePath = relativePathComponents.joined(separator: "/")
		if hasDirectoryPath {
			relativePath += "/"
		}
		if let query {
			relativePath += "?\(query)"
		}
		if let fragment {
			relativePath += "#\(fragment)"
		}

		return URL(string: relativePath, relativeTo: base) ?? self
	}

}
