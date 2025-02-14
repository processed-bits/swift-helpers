// URLComponents+BaseURL.swift, 11.01.2025-29.01.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

import Foundation

public extension URLComponents {

	// MARK: Validating and Deriving a Base URL

	/// A Boolean that is true if the URL components are *valid for use* as a base URL according to RFC 3986.
	///
	/// The components must have non-`nil` scheme and host components. Either the host must be non-empty, or the path must be starting with a slash (`/`).
	///
	/// These requirements ensure that the URL components will conform to the [absolute URI](<doc:URIReferenceKind/URIKind/absolute>) syntax rule, and that the URL has a hierarchical path.
	///
	/// To manually derive conforming base URL components, use ``asBaseURL`` property.
	///
	/// See [URL Handling](<doc:URLHandling#Base-URLs>) for more information.
	var isValidBaseURL: Bool {
		guard scheme != nil, let host else {
			return false
		}
		lazy var hasAbsolutePath = path.hasPrefix("/")
		return !host.isEmpty || hasAbsolutePath
	}

	/// A version of the URL components conforming to RFC 3986 base URL requirements.
	///
	/// The resulting components must conform to the [absolute URI](<doc:URIReferenceKind/URIKind/absolute>) syntax rule and be stripped of any fragment component (RFC 3986 [Section 5.1](https://datatracker.ietf.org/doc/html/rfc3986#section-5.1)).
	///
	/// If the URL components path is empty, it will be normalized to `/` (RFC 3986 [Section 6.2.3](https://datatracker.ietf.org/doc/html/rfc3986#section-6.2.3)).
	///
	/// This property returns `nil` if it can’t form valid components from self.
	var asBaseURL: URLComponents? {
		guard isValidBaseURL else {
			return nil
		}
		var components = self
		components.normalizeEmptyPath()
		components.fragment = nil
		return components
	}

}
