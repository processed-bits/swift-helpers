// URIReferenceKind.swift, 27.11.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import StandardLibraryHelpers

/// A type that represents URI reference kind according to RFC 3986.
///
/// - Note: Suffix reference is excluded from available cases. It is a programmer’s task to disambiguate a suffix reference URI. Otherwise, it is parsed as a network-path reference when creating `URLComponents` with an explicit host, or as a relative-path reference when initialized as `URL` or `URLComponents` string.
///
/// The enumeration and its cases, including nested ones, provide corresponding syntax using the ABNF notation (see RFC 3986 [Section 1.3](https://datatracker.ietf.org/doc/html/rfc3986#section-1.3) and [Appendix A](https://datatracker.ietf.org/doc/html/rfc3986#appendix-A) for more information).
///
/// ## Syntax
///
/// ```
/// URI-reference = URI / relative-ref
/// ```
///
/// See RFC 3986 [Section 4.1](https://datatracker.ietf.org/doc/html/rfc3986#section-4.1) for more information.
public enum URIReferenceKind: Equatable, Hashable {

	// MARK: URI and Nested Kinds

	/// A URI consisting of a hierarchical sequence of components.
	///
	/// ## Syntax
	///
	/// ```
	/// URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]
	/// ```
	///
	/// See RFC 3986 [Section 3](https://datatracker.ietf.org/doc/html/rfc3986#section-3) for more information.
	case uri(URIKind)

	public enum URIKind {
		/// A generic URI.
		///
		/// ## Syntax
		///
		/// ```
		/// URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]
		/// ```
		///
		/// See RFC 3986 [Section 3](https://datatracker.ietf.org/doc/html/rfc3986#section-3) for more information.
		case generic

		/// An absolute form of a URI, not allowing a fragment, that may be used as a base URI.
		///
		/// ## Syntax
		///
		/// ```
		/// absolute-URI = scheme ":" hier-part [ "?" query ]
		/// ```
		///
		/// See RFC 3986 [Section 4.3](https://datatracker.ietf.org/doc/html/rfc3986#section-4.3) for more information.
		case absolute
	}

	// MARK: Relative Reference and Nested Kinds

	/// A relative reference.
	///
	/// ## Syntax
	///
	/// ```
	/// relative-ref = relative-part [ "?" query ] [ "#" fragment ]
	/// ```
	///
	/// See RFC 3986 [Section 4.2](https://datatracker.ietf.org/doc/html/rfc3986#section-4.2) for more information.
	case relativeReference(URIRelativeReferenceKind)

	public enum URIRelativeReferenceKind {
		/// A network-path reference, beginning with two slash characters.
		///
		/// ## Syntax
		///
		/// ```
		/// relative-part = "//" authority path-abempty
		/// ```
		///
		/// See RFC 3986 [Section 4.2](https://datatracker.ietf.org/doc/html/rfc3986#section-4.2) for more information.
		case networkPath

		/// An absolute-path reference.
		///
		/// ## Syntax
		///
		/// ```
		/// relative-part = path-absolute
		/// ```
		///
		/// See RFC 3986 [Section 4.2](https://datatracker.ietf.org/doc/html/rfc3986#section-4.2) for more information.
		case absolutePath

		/// A relative-path reference.
		///
		/// ## Syntax
		///
		/// ```
		/// relative-part = path-noscheme
		/// ```
		///
		/// See RFC 3986 [Section 4.2](https://datatracker.ietf.org/doc/html/rfc3986#section-4.2) for more information.
		case relativePath

		/// A same-document reference, that is empty or contains only a fragment component.
		///
		/// ## Syntax
		///
		/// ```
		/// relative-part = path-empty
		/// ```
		///
		/// See RFC 3986 [Section 4.4](https://datatracker.ietf.org/doc/html/rfc3986#section-4.4) for more information.
		case sameDocument
	}

	// MARK: Default Initializer

	/// The default initializer for a URI reference kind.
	///
	/// - Note: This initializer is not meant to be invoked directly. Use respective `URL`’s ``Foundation/URL/referenceKind`` and `URLComponents`’ ``FoundationHelpers/Foundation/URLComponents/referenceKind`` properties, which in turn use this initializer, to get a URI reference kind.
	///
	/// This initializer uses autoclosures for most of its parameters for improved efficiency.
	///
	/// See <doc:URIReferenceKind#Default-Implementation> for more information.
	public init(
		scheme: String?,
		host hostClosure: @autoclosure () -> String?,
		path pathClosure: @autoclosure () -> String,
		query queryClosure: @autoclosure () -> String?,
		fragment fragmentClosure: @autoclosure () -> String?
	) {
		lazy var host = hostClosure()
		lazy var path = pathClosure()
		lazy var query = queryClosure()
		lazy var fragment = fragmentClosure()

		if scheme?.isEmpty == false {
			self = fragment != nil ? .uri(.generic) : .uri(.absolute)
		} else if host != nil {
			self = .relativeReference(.networkPath)
		} else if path.hasPrefix("/") {
			self = .relativeReference(.absolutePath)
		} else if path.isEmpty, query == nil {
			self = .relativeReference(.sameDocument)
		} else {
			self = .relativeReference(.relativePath)
		}
	}

}

// MARK: - Conformances

extension URIReferenceKind: CustomStringConvertible {
	public var description: String {
		switch self {
		case let .uri(uriKind):
			"URI, \(uriKind.description.lowercasedFirstLetter)"
		case let .relativeReference(uriRelativeReferenceKind):
			"Relative reference, \(uriRelativeReferenceKind.description.lowercasedFirstLetter)"
		}
	}
}

extension URIReferenceKind.URIKind: CustomStringConvertible {
	public var description: String {
		switch self {
		case .generic:
			"Generic"
		case .absolute:
			"Absolute"
		}
	}
}

extension URIReferenceKind.URIRelativeReferenceKind: CustomStringConvertible {
	public var description: String {
		switch self {
		case .networkPath:
			"Network-path"
		case .absolutePath:
			"Absolute-path"
		case .relativePath:
			"Relative-path"
		case .sameDocument:
			"Same-document"
		}
	}
}
