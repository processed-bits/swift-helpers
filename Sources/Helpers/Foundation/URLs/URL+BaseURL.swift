// URL+BaseURL.swift, 05.04.2024-13.01.2025.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation

@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, visionOS 1.0, watchOS 9.0, *)
public extension URL {

	// MARK: Validating and Deriving a Base URL

	/// A Boolean that is true if the URL is *valid for use* as a base URL according to RFC 3986.
	///
	/// The URL must have non-`nil` scheme and host components. Either the host must be non-empty, or the path must be starting with a slash (`/`).
	///
	/// These requirements ensure that the URL will conform to the [absolute URI](<doc:URIReferenceKind/URIKind/absolute>) syntax rule, and that the URL has a hierarchical path.
	///
	/// To manually derive a conforming base URL, use ``asBaseURL`` property.
	///
	/// See [URL Handling](<doc:URLHandling#Base-URLs>) for more information.
	var isValidBaseURL: Bool {
		guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
			return false
		}
		return components.isValidBaseURL
	}

	/// A version of the URL conforming to RFC 3986 base URL requirements.
	///
	/// The resulting URL must conform to the [absolute URI](<doc:URIReferenceKind/URIKind/absolute>) syntax rule and be stripped of any fragment component (RFC 3986 [Section 5.1](https://datatracker.ietf.org/doc/html/rfc3986#section-5.1)).
	///
	/// If the URL path is empty, it will be normalized to `/` (RFC 3986 [Section 6.2.3](https://datatracker.ietf.org/doc/html/rfc3986#section-6.2.3)).
	///
	/// This property returns `nil` if it can’t form a valid URL from self.
	var asBaseURL: URL? {
		guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
			return nil
		}
		return components.asBaseURL?.url
	}

}
