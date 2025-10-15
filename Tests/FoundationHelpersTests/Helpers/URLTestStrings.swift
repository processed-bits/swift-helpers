// URLTestStrings.swift, 04.03.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

import Foundation
import FoundationHelpers
import Testing

/// Test strings for URL components encoding testing.
struct URLTestStrings {

	let scheme: String?
	let user: String?
	let password: String?
	let host: String?
	let path: String
	let query: String?
	let fragment: String?

	var encodedUser: String? { user?.encoded(with: .urlUserAllowed) }
	var encodedPassword: String? { password?.encoded(with: .urlPasswordAllowed) }
	var encodedHost: String? { host?.encoded(with: .urlHostAllowed) }
	var encodedPath: String? { path.encoded(with: .urlPathAllowed) }
	var encodedQuery: String? { query?.encoded(with: .urlQueryAllowed) }
	var encodedFragment: String? { fragment?.encoded(with: .urlFragmentAllowed) }

	var encodedUserRFC: String? { user?.encoded(with: .urlUserAllowedRFC3986) }
	var encodedPasswordRFC: String? { password?.encoded(with: .urlPasswordAllowedRFC3986) }
	var encodedHostRFC: String? { host?.encoded(with: .urlHostAllowedRFC3986) }
	var encodedPathRFC: String? { path.encoded(with: .urlPathAllowedRFC3986) }
	var encodedQueryRFC: String? { query?.encoded(with: .urlQueryAllowedRFC3986) }
	var encodedFragmentRFC: String? { fragment?.encoded(with: .urlFragmentAllowedRFC3986) }

	// MARK: Test Strings Sets

	private static let unreserved = "az09-._~"
	private static let generalDelimiters = ":/?#[]@"
	private static let subDelimiters = "!$&'()*+,;="
	private static let percent = "%"
	private static let all = "\(unreserved)\(generalDelimiters)\(subDelimiters)\(percent)"

	// swiftformat:disable indent
	/// Allowed characters, not requiring encoding.
	///
	/// - Host omits `[]:`, which are allowed for IP literals.
	static let allowed = Self(
		scheme:
			"x-09+.",
		user:
			"USER_____\(unreserved)\(subDelimiters)",
		password:
			"PASSWORD_\(unreserved)\(subDelimiters)",
		host:
			"host_____\(unreserved)\(subDelimiters)",
		path:
			"/PATH____\(unreserved)\(subDelimiters)/:@",
		query:
			"QUERY____\(unreserved)\(subDelimiters)/:@?",
		fragment:
			"FRAGMENT_\(unreserved)\(subDelimiters)/:@?"
	)

	/// Mixed characters, requiring encoding, except for the scheme and host strings using allowed characters.
	static let mixed = Self(
		scheme:
			allowed.scheme,
		user:
			"USER_____\(all)",
		password:
			"PASSWORD_\(all)",
		host:
			allowed.host,
		path:
			"/PATH____\(all)",
		query:
			"QUERY____\(all)",
		fragment:
			"FRAGMENT_\(all)"
	)
	// swiftformat:enable indent

	// MARK: URL Components

	var components: URLComponents {
		URLComponents(
			scheme: scheme,
			user: user,
			password: password,
			host: host,
			path: path,
			query: query,
			fragment: fragment
		)
	}

	func rfcEncodedComponents(sourceLocation: SourceLocation = #_sourceLocation) throws -> URLComponents {
		try URLComponents.encoded(
			scheme: scheme,
			user: encodedUserRFC,
			password: encodedPasswordRFC,
			host: encodedHostRFC,
			path: #require(encodedPathRFC, sourceLocation: sourceLocation),
			query: encodedQueryRFC,
			fragment: encodedFragmentRFC
		)
	}

	func overEncodedComponents(sourceLocation: SourceLocation = #_sourceLocation) throws -> URLComponents {
		try URLComponents.encoded(
			scheme: scheme,
			user: user?.encoded(),
			password: password?.encoded(),
			host: host?.encoded(),
			path: #require(path.encoded(), sourceLocation: sourceLocation),
			query: query?.encoded(),
			fragment: fragment?.encoded()
		)
	}

}

// MARK: - Helpers

extension String {
	func encoded(with allowedCharacters: CharacterSet = .empty) -> String? {
		addingPercentEncoding(withAllowedCharacters: allowedCharacters)
	}

	var hasPercentEncoding: Bool {
		let regex = /%[0-9A-F]{2}/.ignoresCase()
		return contains(regex)
	}
}

// MARK: - Tests

struct URLTestStringsTests {
	@Test func allowedHasNoEncoding() {
		let strings = URLTestStrings.allowed
		#expect(strings.encodedUserRFC?.hasPercentEncoding == false)
		#expect(strings.encodedPasswordRFC?.hasPercentEncoding == false)
		#expect(strings.encodedHostRFC?.hasPercentEncoding == false)
		#expect(strings.encodedPathRFC?.hasPercentEncoding == false)
		#expect(strings.encodedQueryRFC?.hasPercentEncoding == false)
		#expect(strings.encodedFragmentRFC?.hasPercentEncoding == false)
	}
}
