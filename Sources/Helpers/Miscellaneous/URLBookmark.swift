// URLBookmark.swift, 20.03.2020-28.02.2023.
// Copyright © 2020-2023 Stanislav Lomachinskiy.

import Foundation

/// A URL bookmark object.
///
/// You can initialize an object with existing bookmark data or create bookmark data with a URL.
///
/// Add an appropriate entitlement for security-scoped bookmarks:
///
/// - `com.apple.security.files.bookmarks.app-scope`
/// - `com.apple.security.files.bookmarks.document-scope`
public class URLBookmark {

	/// Bookmark data.
	public private(set) var data: Data?
	/// If `true`, the bookmark data is stale.
	public private(set) var isStale = false

	private let creationOptions: URL.BookmarkCreationOptions
	private let resolutionOptions: URL.BookmarkResolutionOptions
	private let keys: Set<URLResourceKey>?
	private let relativeURL: URL?

	// MARK: Creating a URL Bookmark Object

	/// All parameters except for bookmark data must be set during initialization to required values.
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
	public init(data: Data? = nil, creationOptions: URL.BookmarkCreationOptions = [], resolutionOptions: URL.BookmarkResolutionOptions = [], includingResourceValuesForKeys keys: Set<URLResourceKey>? = nil, relativeTo relativeURL: URL? = nil) {
		self.data = data
		self.creationOptions = creationOptions
		self.resolutionOptions = resolutionOptions
		self.keys = keys
		self.relativeURL = relativeURL
	}

	// MARK: Creating and Resolving

	/// Creates bookmark data for the URL.
	public func create(with url: URL?) throws {
		data = try url?.bookmarkData(options: creationOptions, includingResourceValuesForKeys: keys, relativeTo: relativeURL)
		isStale = false
	}

	/// Returns a URL that refers to a location specified by resolving bookmark data.
	///
	/// The object tries to recreate stale bookmark data automatically. If data cannot be recreated, no error is thrown, but `isStale` property will resolve to `true`.
	public func resolve() throws -> URL? {
		guard let data else {
			return nil
		}
		let url = try URL(resolvingBookmarkData: data, options: resolutionOptions, relativeTo: relativeURL, bookmarkDataIsStale: &isStale)
		// We should create a new bookmark using the returned URL and use it in place of any stored copies of the existing bookmark.
		if isStale {
			var isAccessingSecurityScopedResource = false
			if creationOptions.contains(.withSecurityScope) {
				isAccessingSecurityScopedResource = url.startAccessingSecurityScopedResource()
			}
			defer {
				if creationOptions.contains(.withSecurityScope), isAccessingSecurityScopedResource {
					url.stopAccessingSecurityScopedResource()
				}
			}
			// Recreate stale data if possible.
			try? create(with: url)
		}
		return url
	}

}
