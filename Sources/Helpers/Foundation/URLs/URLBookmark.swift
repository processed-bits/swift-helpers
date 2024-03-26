// URLBookmark.swift, 20.03.2020-26.03.2024.
// Copyright © 2020-2024 Stanislav Lomachinskiy.

import Foundation

/// A URL bookmark struct.
///
/// You can initialize a struct with existing bookmark data or create bookmark data with a URL.
///
/// Add appropriate entitlements for application or document security-scoped bookmarks:
///
/// - `com.apple.security.files.bookmarks.app-scope`
/// - `com.apple.security.files.bookmarks.document-scope`
public struct URLBookmark: Codable {

	/// Bookmark data.
	public private(set) var data: Data?
	/// If `true`, the bookmark data is stale. This property is updated after accessing the ``resolve()`` method.
	public private(set) var isStale = false

	/// Options used when creating bookmark data.
	public let creationOptions: URL.BookmarkCreationOptions
	/// Options used when resolving bookmark data.
	public let resolutionOptions: URL.BookmarkResolutionOptions
	/// Keys for resource values to be included when creating bookmark data.
	public let keys: Set<URLResourceKey>?
	/// The base URL that the bookmark data is relative to.
	public let baseURL: URL?

	enum CodingKeys: CodingKey {
		case data
		case creationOptions
		case resolutionOptions
		case keys
		case baseURL
	}

	// MARK: Creating a URL Bookmark Object

	/// Creates a URL bookmark. All parameters except for bookmark data must be set during initialization.
	///
	/// - Parameters:
	///   - data: Bookmark data.
	///   - creationOptions: Options used when creating bookmark data.
	///   - resolutionOptions: Options used when resolving bookmark data.
	///   - keys: Keys for resource values to be included when creating bookmark data.
	///   - relativeURL: The base URL that the bookmark data is relative to.
	///
	///     If you’re resolving a security-scoped bookmark to obtain a security-scoped URL, use this parameter as follows:
	///
	///     - To resolve an app-scoped bookmark, use a value of `nil`.
	///     - To resolve a document-scoped bookmark, use the *absolute* path (despite this parameter’s name) to the document from which you retrieved the bookmark.
	public init(
		data: Data? = nil,
		creationOptions: URL.BookmarkCreationOptions = [],
		resolutionOptions: URL.BookmarkResolutionOptions = [],
		includingResourceValuesForKeys keys: Set<URLResourceKey>? = nil,
		relativeTo baseURL: URL? = nil
	) {
		self.data = data
		self.creationOptions = creationOptions
		self.resolutionOptions = resolutionOptions
		self.keys = keys
		self.baseURL = baseURL
	}

	// MARK: Creating and Resolving

	/// Creates bookmark data for the URL.
	public mutating func create(with url: URL?) throws {
		data = try url?.bookmarkData(options: creationOptions, includingResourceValuesForKeys: keys, relativeTo: baseURL)
		isStale = false
	}

	/// Returns a URL that refers to a location specified by resolving bookmark data.
	///
	/// This method tries to recreate stale bookmark data automatically. If data cannot be recreated, no error is thrown, but `isStale` property will resolve to `true`.
	public mutating func resolve() throws -> URL? {
		guard let data else {
			return nil
		}
		let url = try URL(resolvingBookmarkData: data, options: resolutionOptions, relativeTo: baseURL, bookmarkDataIsStale: &isStale)
		// Create a new bookmark using the returned URL and use it in place of any stored copies of the existing bookmark.
		if isStale {
			#if os(macOS) || targetEnvironment(macCatalyst)
				var isAccessingSecurityScopedResource = false
				if creationOptions.contains(.withSecurityScope) {
					isAccessingSecurityScopedResource = url.startAccessingSecurityScopedResource()
				}
				defer {
					if creationOptions.contains(.withSecurityScope), isAccessingSecurityScopedResource {
						url.stopAccessingSecurityScopedResource()
					}
				}
			#endif
			// Recreate stale data if possible.
			try? create(with: url)
		}
		return url
	}

}

extension URL.BookmarkCreationOptions: Codable {}
extension URL.BookmarkResolutionOptions: Codable {}
extension URLResourceKey: Codable {}
