// URLComponents+Normalization.swift, 14.12.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation

public extension URLComponents {

	// MARK: Normalization

	/// Normalizes the URL components.
	///
	/// - Parameters:
	///   - lowercasePath: If `true`, the path is converted to lowercase. Do so only if licensed by the scheme specification. Defaults to `false`.
	///   - schemePortPairs: A collection of schemes and their default port values. Defaults to ``defaultNormalizedPorts``.
	///   - removeEmptyPathComponents: If `true`, empty path components are removed, effectively collapsing consecutive path separators. Do so only if licensed by the scheme specification. Defaults to `false`.
	///
	/// Includes normalization of:
	/// - case (``normalizeCase(lowercasePath:)``);
	/// - percent-encoding (``normalizePercentEncoding(skipHost:)``);
	/// - port (``normalizePort(schemePortPairs:)``);
	/// - path (``normalizePathLexically(removeEmptyComponents:)``, ``normalizeEmptyPath()``).
	///
	/// See <doc:URLNormalization#Normalization> and related methods for more information.
	@available(iOS 16.0, macCatalyst 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	mutating func normalize(
		lowercasePath: Bool = false,
		schemePortPairs: [String: Int] = Self.defaultNormalizedPorts,
		removeEmptyPathComponents: Bool = false
	) {
		normalizeCase(lowercasePath: lowercasePath)
		normalizePercentEncoding(skipHost: true)
		normalizePort(schemePortPairs: schemePortPairs)
		normalizePathLexically(removeEmptyComponents: removeEmptyPathComponents)
		normalizeEmptyPath()
	}

	// MARK: Syntax-Based Normalization

	/// Normalizes the scheme, the host, and optionally the path to their lowercased versions.
	///
	/// - Parameter lowercasePath: If `true`, the path is converted to lowercase. Do so only if licensed by the scheme specification. Defaults to `false`.
	///
	/// As a side effect, percent-encoding of the host will also be normalized.
	///
	/// See RFC 3986 [Section 6.2.2.1](https://datatracker.ietf.org/doc/html/rfc3986#section-6.2.2.1) for more information.
	mutating func normalizeCase(lowercasePath: Bool = false) {
		scheme = scheme?.lowercased()
		host = host?.lowercased()
		if lowercasePath {
			path = path.lowercased()
		}
	}

	/// Normalizes percent-encoding of the user, password, host, path, query, and fragment components.
	///
	/// - Parameter skipHost: A flag to skip the host component if ``normalizeCase(lowercasePath:)`` has been invoked previously. Defaults to`false`.
	///
	/// See RFC 3986 [Section 6.2.2.2](https://datatracker.ietf.org/doc/html/rfc3986#section-6.2.2.2) and [URL Handling](<doc:URLHandling#Percent-Encoding-of-User-and-Password-Components>) for more information.
	@available(iOS 16.0, macCatalyst 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	mutating func normalizePercentEncoding(skipHost: Bool = false) {
		// `URLComponents`’ `user` and `password` setters do not encode a colon. Appropriate percent-encoding is enforced manually.
		percentEncodedUser = user?.addingPercentEncoding(withAllowedCharacters: .urlUserAllowedRFC3986)
		percentEncodedPassword = password?.addingPercentEncoding(withAllowedCharacters: .urlPasswordAllowedRFC3986)

		if !skipHost {
			// Getter removes percent-encoding, setter uses IDNA encoding if needed.
			host = host
		}
		// Getters remove all percent-encoding, setters add appropriate percent-encoding.
		if let percentEncodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowedRFC3986) {
			self.percentEncodedPath = percentEncodedPath
		}
		query = query
		fragment = fragment
	}

	/// Normalizes the path by collapsing current directory (`.`) and parent directory (`..`) components lexically (i.e. without following symlinks).
	///
	/// - Parameter removeEmptyComponents: If `true`, empty path components are removed, effectively collapsing consecutive path separators. Do so only if licensed by the scheme specification. Defaults to `false`.
	///
	/// See RFC 3986 [Section 6.2.2.3](https://datatracker.ietf.org/doc/html/rfc3986#section-6.2.2.3) and[URL Normalization](<doc:URLNormalization#Lexical-Normalization>) for more information.
	mutating func normalizePathLexically(removeEmptyComponents: Bool = false) {
		var path = HierarchicalPath(path: path)
		path.lexicallyNormalize()
		if removeEmptyComponents {
			path.removeEmptyComponents()
		}
		if referenceKind == .relativeReference(.relativePath) {
			path.normalizeRelativePathReference()
		}
		self.path = path.string
	}

	// MARK: Scheme-Based Normalization

	/// Normalizes the port component by removing it when a default port is used for a scheme.
	///
	/// - Parameter schemePortPairs: A collection of schemes and their default port values. Defaults to ``defaultNormalizedPorts``.
	///
	/// See RFC 3986 [Section 6.2.3](https://datatracker.ietf.org/doc/html/rfc3986#section-6.2.3) for more information.
	mutating func normalizePort(schemePortPairs: [String: Int] = Self.defaultNormalizedPorts) {
		if let scheme, schemePortPairs[scheme] == port {
			port = nil
		}
	}

	/// The most used scheme and default port assignments per [IANA registry](https://www.iana.org/assignments/port-numbers), that are used for URL normalization by default.
	///
	///	The default is a dictionary with ports 21, 22, 80, 443.
	static let defaultNormalizedPorts: [String: Int] = [
		"ftp": 21,
		"ssh": 22,
		// swiftlint:disable:next force_https
		"http": 80,
		"https": 443,
	]

	/// Normalizes an empty path to “`/`” when authority is present.
	///
	/// See RFC 3986 [Section 6.2.3](https://datatracker.ietf.org/doc/html/rfc3986#section-6.2.3) for more information.
	mutating func normalizeEmptyPath() {
		if path.isEmpty, let host, !host.isEmpty {
			path = "/"
		}
	}

}

// MARK: - Private Helpers

private extension String {
	static let encodedColon = "%3A"
}

@available(iOS 16.0, macCatalyst 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
private extension Regex<Substring> {
	nonisolated(unsafe) static let encodedColon: Self = /%3A/.ignoresCase()
}
