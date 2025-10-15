// URL+BaseURL.swift, 05.04.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation

@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
public extension URL {

	// MARK: Validating and Deriving a Base URL

	/// A Boolean that is true if the URL is *valid for use* as a base URL according to RFC 3986.
	///
	/// The URL must have a scheme subcomponent present (RFC 3986 [Section 5.1](https://datatracker.ietf.org/doc/html/rfc3986#section-5.1)). This requirement ensures that the URL components *may* conform to the [absolute URI](<doc:URIReferenceKind/URIKind/absolute>) syntax rule.
	///
	/// To derive a conforming base URL, use ``asBaseURL`` property.
	///
	/// See [URL Handling](<doc:URLHandling#Base-URLs>) for more information.
	var isValidForBaseURL: Bool {
		guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
			return false
		}
		return components.isValidForBaseURL
	}

	/// A version of the URL conforming to RFC 3986 base URL requirements.
	///
	/// The resulting URL must conform to the [absolute URI](<doc:URIReferenceKind/URIKind/absolute>) syntax rule, stripped of any fragment component (RFC 3986 [Section 5.1](https://datatracker.ietf.org/doc/html/rfc3986#section-5.1)).
	///
	/// If the URL path is empty, it will be normalized to “`/`” (RFC 3986 [Section 6.2.3](https://datatracker.ietf.org/doc/html/rfc3986#section-6.2.3)).
	///
	/// This property returns `nil` if it can’t form a valid URL from self.
	var asBaseURL: URL? {
		guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
			return nil
		}
		return components.asBaseURL?.url
	}

}
