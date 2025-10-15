// URLComponents+BaseURL.swift, 11.01.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

import Foundation

public extension URLComponents {

	// MARK: Validating and Deriving a Base URL

	/// A Boolean that is true if the URL components are *valid for use* for a base URL according to RFC 3986.
	///
	/// The components must have a scheme subcomponent present (RFC 3986 [Section 5.1](https://datatracker.ietf.org/doc/html/rfc3986#section-5.1)). This requirement ensures that the URL components *may* conform to the [absolute URI](<doc:URIReferenceKind/URIKind/absolute>) syntax rule.
	///
	/// To derive conforming base URL components, use ``asBaseURL`` property.
	///
	/// See [URL Handling](<doc:URLHandling#Base-URLs>) for more information.
	var isValidForBaseURL: Bool {
		scheme?.isEmpty == false
	}

	/// A version of the URL components conforming to RFC 3986 base URL requirements.
	///
	/// The resulting URL components must conform to the [absolute URI](<doc:URIReferenceKind/URIKind/absolute>) syntax rule, stripped of any fragment subcomponent (RFC 3986 [Section 5.1](https://datatracker.ietf.org/doc/html/rfc3986#section-5.1)).
	///
	/// If the URL components‘ path is empty, it will be normalized to “`/`” (RFC 3986 [Section 6.2.3](https://datatracker.ietf.org/doc/html/rfc3986#section-6.2.3)).
	///
	/// This property returns `nil` if it can’t form valid components from self.
	var asBaseURL: URLComponents? {
		guard isValidForBaseURL else {
			return nil
		}
		var components = self
		components.normalizeEmptyPath()
		components.fragment = nil
		return components
	}

}
