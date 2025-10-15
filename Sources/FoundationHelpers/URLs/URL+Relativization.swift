// URL+Relativization.swift, 28.02.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation

@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
public extension URL {

	/// A Boolean that is true if self and other URLs have the same scheme, user, password, host and port components.
	func isRelative(of other: URL) -> Bool {
		(
			scheme,
			user(percentEncoded: false),
			password(percentEncoded: false),
			host(percentEncoded: false),
			port
		) == (
			other.scheme,
			other.user(percentEncoded: false),
			other.password(percentEncoded: false),
			other.host(percentEncoded: false),
			other.port
		)
	}

	/// Returns a URL that is relativized to another URL.
	///
	/// - Parameters:
	///   - other: The base URL to which the current URL will be relativized.
	///   - allowAscending: If `true`, the path of a relativized URL is allowed to escape from the base by beginning with one or more parent directory components (`..`). The default is `false`.
	///
	/// If `other` can’t conform to RFC 3986 base URL requirements, this method returns `nil`. If `self` is not a relative of the base URL, this method returns `nil`. See ``asBaseURL`` and ``isRelative(of:)`` for more information.
	///
	/// You may want to lexically normalize `self` and `base` before calling this method. This method doesn’t percent-recode query and fragment components.
	func relativized(to other: URL, allowAscending: Bool = false) -> URL? {
		guard let base = other.asBaseURL, isRelative(of: base) else {
			return nil
		}

		var inputPath = HierarchicalPath(from: self)
		// Normalize empty input path.
		if inputPath.components.isEmpty, host(percentEncoded: false) != nil {
			inputPath.isAbsolute = true
		}

		var baseDirectoryPath = HierarchicalPath(from: base)
		// Remove non-directory base path component, if any, for later comparison.
		baseDirectoryPath.removeNonDirectoryComponent()

		// Count common path components.
		let commonPathComponentsCount = zip(inputPath.components, baseDirectoryPath.components)
			.prefix { $0.0 == $0.1 }
			.count

		var outputPath = inputPath
		// Remove common path components from output.
		outputPath.components.removeFirst(commonPathComponentsCount)
		outputPath.isAbsolute = false

		let levelsUp = baseDirectoryPath.components.count - commonPathComponentsCount
		if levelsUp > 0 {
			guard allowAscending else {
				return nil
			}

			// Prepend parent directory components to output.
			outputPath.components = Array(repeating: .parentDirectory, count: levelsUp) + outputPath.components

			// If input path is referencing root, add trailing separator to output.
			if inputPath.isRoot {
				outputPath.hasDirectoryPath = true
			}
		}

		let percentEncodedQuery = query(percentEncoded: true)
		let percentEncodedFragment = fragment(percentEncoded: true)

		// If output path is empty, and there are no query and fragment components, add a current directory component.
		if outputPath.components.isEmpty, percentEncodedQuery == nil, percentEncodedFragment == nil {
			outputPath.components.append(.currentDirectory)
		}

		outputPath.normalizeRelativePathReference()

		// A relative-path URL has no scheme and authority components. Only path, query and fragment are used.
		var components = URLComponents()
		components.path = outputPath.string
		// Do not percent recode query and fragment.
		components.percentEncodedQuery = percentEncodedQuery
		components.percentEncodedFragment = percentEncodedFragment

		return components.url(relativeTo: base)
	}

	/// Makes the URL relativized to another URL.
	///
	/// - Parameters:
	///   - base: The base URL to which the current URL will be relativized.
	///   - allowAscending: If `true`, the path of a relativized URL is allowed to escape from the base by beginning with one or more parent directory components (`..`). The default is `false`.
	///
	/// - Returns: `true` if the URL has been relativized.
	///
	/// If `base` can’t conform to RFC 3986 base URL requirements, this method returns `nil`. If `self` is not a relative of the base URL, this method returns `nil`. You may want to lexically normalize `self` and `base` before calling this method.
	///
	/// See ``asBaseURL`` and ``isRelative(of:)`` for more information.
	@discardableResult mutating func relativize(to base: URL, allowAscending: Bool = false) -> Bool {
		if let relativized = relativized(to: base, allowAscending: allowAscending) {
			self = relativized
			return true
		}
		return false
	}

}

// MARK: - Private Helpers

/// Hierarchical path extensions.
private extension String {
	static let currentDirectory = "."
	static let parentDirectory = ".."
}
