// URLComponentsPercentEncodingTests.swift, 31.12.2024-30.01.2025.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation
import Testing

private struct TestStrings {
	private static let unreserved = "Az09-._~"
	private static let generalDelimiters = ":/?#[]@"
	private static let subDelimiters = "!$&'()*+,;="
	private static let percent = "%"
	private static let all = "\(unreserved)_\(generalDelimiters)_\(subDelimiters)_\(percent)"

	let scheme: String?
	let user: String?
	let password: String?
	let host: String?
	let path: String
	let query: String?
	let fragment: String?

	var percentEncodedUser: String? { user?.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) }
	var percentEncodedUserExcludingColon: String? { user?.addingPercentEncoding(withAllowedCharacters: .urlUserAllowedWithColon) }
	var percentEncodedPassword: String? { password?.addingPercentEncoding(withAllowedCharacters: .urlPasswordAllowed) }
	var percentEncodedPasswordExcludingColon: String? { password?.addingPercentEncoding(withAllowedCharacters: .urlPasswordAllowedWithColon) }
	var encodedHost: String? { host?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) }
	var percentEncodedPath: String? { path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) }
	var percentEncodedQuery: String? { query?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) }
	var percentEncodedFragment: String? { fragment?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) }

	// swiftformat:disable indent
	static let allowed = TestStrings(
		scheme:
			"HTTPS",
		user:
			"USER_____\(unreserved)_\(subDelimiters)",
		password:
			"PASSWORD_\(unreserved)_\(subDelimiters)",
		host:
			"HOST_____\(unreserved)_\(subDelimiters)",
		path:
			"/PATH____\(unreserved)_\(subDelimiters)_:@",
		query:
			"QUERY____\(unreserved)_\(subDelimiters)_/?",
		fragment:
			"FRAGMENT_\(unreserved)_\(subDelimiters)_/?"
	)

	static let mixed = TestStrings(
		scheme:
			"HTTPS",
		user:
			"USER_____\(all)",
		password:
			"PASSWORD_\(all)",
		host:
			"HOST_____\(all)",
		path:
			"/PATH____\(all)",
		query:
			"QUERY____\(all)",
		fragment:
			"FRAGMENT_\(all)"
	)
	// swiftformat:enable indent
}

private extension StringProtocol {
	var percentEncoded: String? { addingPercentEncoding(withAllowedCharacters: .empty) }
}

private extension URLComponents {
	/// Asserts that the URL components (user, password, host, path, query, fragment) contain percent-encoded characters.
	@discardableResult func assertHasPercentEncoding(_ expected: Bool = true, sourceLocation: SourceLocation = #_sourceLocation) throws -> Self {
		#expect(expected == (user != percentEncodedUser), sourceLocation: sourceLocation)
		#expect(expected == (password != percentEncodedPassword), sourceLocation: sourceLocation)
		#expect(expected == (host != encodedHost), sourceLocation: sourceLocation)
		#expect(expected == (path != percentEncodedPath), sourceLocation: sourceLocation)
		#expect(expected == (query != percentEncodedQuery), sourceLocation: sourceLocation)
		#expect(expected == (fragment != percentEncodedFragment), sourceLocation: sourceLocation)
		return self
	}

	/// Asserts that the URL components (user, password, host, path, query, fragment) are equal to their `TestString` counterparts.
	@discardableResult func assertEquals(strings: TestStrings, sourceLocation: SourceLocation = #_sourceLocation) throws -> Self {
		#expect(user == strings.user, sourceLocation: sourceLocation)
		#expect(password == strings.password, sourceLocation: sourceLocation)
		#expect(host == strings.host, sourceLocation: sourceLocation)
		#expect(path == strings.path, sourceLocation: sourceLocation)
		#expect(query == strings.query, sourceLocation: sourceLocation)
		#expect(fragment == strings.fragment, sourceLocation: sourceLocation)
		return self
	}

	/// Asserts that the percent-encoded URL components (user, password, host, path, query, fragment) are equal to their `TestString` percent-encoded counterparts.
	///
	/// User and password components percent-encode colons according to `encodingColon` parameter.
	@discardableResult func assertEquals(percentEncodedStrings strings: TestStrings, encodingColon: Bool, sourceLocation: SourceLocation = #_sourceLocation) throws -> Self {
		if encodingColon {
			#expect(percentEncodedUser == strings.percentEncodedUser, sourceLocation: sourceLocation)
			#expect(percentEncodedPassword == strings.percentEncodedPassword, sourceLocation: sourceLocation)
		} else {
			#expect(percentEncodedUser == strings.percentEncodedUserExcludingColon, sourceLocation: sourceLocation)
			#expect(percentEncodedPassword == strings.percentEncodedPasswordExcludingColon, sourceLocation: sourceLocation)
		}
		#expect(encodedHost == strings.encodedHost, sourceLocation: sourceLocation)
		#expect(percentEncodedPath == strings.percentEncodedPath, sourceLocation: sourceLocation)
		#expect(percentEncodedQuery == strings.percentEncodedQuery, sourceLocation: sourceLocation)
		#expect(percentEncodedFragment == strings.percentEncodedFragment, sourceLocation: sourceLocation)
		return self
	}
}

struct URLComponentsPercentEncodingTests {

	// MARK: Colon

	@Test func colonPercentEncoding() throws {
		// Percent-encoded colon.
		#expect(CharacterSet.urlUserAllowed.contains(":") == false)
		#expect(CharacterSet.urlPasswordAllowed.contains(":") == false)
		#expect(":".addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) == "%3A")
		#expect(":".addingPercentEncoding(withAllowedCharacters: .urlPasswordAllowed) == "%3A")

		// Plain colon.
		#expect(CharacterSet.urlUserAllowedWithColon.contains(":"))
		#expect(CharacterSet.urlPasswordAllowedWithColon.contains(":"))
		#expect(":".addingPercentEncoding(withAllowedCharacters: .urlUserAllowedWithColon) == ":")
		#expect(":".addingPercentEncoding(withAllowedCharacters: .urlPasswordAllowedWithColon) == ":")
	}

	// MARK: User and Password

	/// `CharacterSet.urlUserAllowed` and `urlPasswordAllowed` do not contain a colon (`:`), so it should be percent-encoded. Still `URLComponents` structure does not percent-encode colon for user and password components.
	@Test func userPasswordPercentEncoding() throws {
		// Additional test for `URL` instead of `URLComponents`.
		var url = try URL(requireString: "https://a:b:c@host")
		#expect(url.user(percentEncoded: true) == "a")
		#expect(url.password(percentEncoded: true) == "b:c")
		url.normalize()
		#expect(url.password(percentEncoded: true) == "b:c")

		var components1 = try URLComponents(requireString: "https://a:b:c@host")
		#expect(components1.percentEncodedUser == "a")
		#expect(components1.percentEncodedPassword == "b:c")
		components1.normalizePercentEncoding()
		#expect(components1.percentEncodedPassword == "b:c")

		if #available(iOS 17.0, macOS 14.0, macCatalyst 17.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *) {
			var components2 = try #require(URLComponents(string: "https://a:b:c@host", encodingInvalidCharacters: true))
			#expect(components2.percentEncodedUser == "a")
			#expect(components2.percentEncodedPassword == "b:c")
			components2.normalizePercentEncoding()
			#expect(components2.percentEncodedPassword == "b:c")
		}

		var encodedComponents = try URLComponents(requireString: "https://a%3Ab%3Ac@host")
		#expect(encodedComponents.percentEncodedUser == "a%3Ab%3Ac")
		#expect(encodedComponents.percentEncodedPassword == nil)
		encodedComponents.normalizePercentEncoding()
		#expect(encodedComponents.percentEncodedUser == "a%3Ab%3Ac")
	}

	// MARK: Host

	/// Tests percent-encoding using `host`, `encodedHost`, deprecated `percentEncodedHost` properties, and using string initializer.
	@Test func hostPercentEncoding() throws {
		let allEncodedHost = try #require(TestStrings.mixed.host?.percentEncoded)

		// Setting percent-encoded host.
		var components = URLComponents.percentEncoded(scheme: "https", host: allEncodedHost)
		#expect(components.host != components.encodedHost)
		#expect(components.host == TestStrings.mixed.host)
		#expect(components.encodedHost == allEncodedHost)
		components.normalizePercentEncoding()
		#expect(components.encodedHost == TestStrings.mixed.encodedHost)

		// Setting deprecated percent-encoded host.
		let deprecatedComponents = {
			var components = URLComponents()
			components.scheme = "https"
			components.percentEncodedHost = allEncodedHost
			return components
		}()
		#expect(deprecatedComponents.host != deprecatedComponents.percentEncodedHost)
		#expect(deprecatedComponents.host == TestStrings.mixed.host)
		// Deprecated `percentEncodedHost` setter removes percent-encoding for allowed characters.
		#expect(deprecatedComponents.percentEncodedHost != allEncodedHost)
		#expect(deprecatedComponents.percentEncodedHost == TestStrings.mixed.encodedHost)

		// Initializing from string with a percent-encoded host.
		var stringComponents = try URLComponents(requireString: "https://" + allEncodedHost)
		#expect(stringComponents.host != stringComponents.encodedHost)
		#expect(stringComponents.host == TestStrings.mixed.host)
		#expect(stringComponents.encodedHost == allEncodedHost)
		stringComponents.normalizePercentEncoding()
		#expect(stringComponents.encodedHost == TestStrings.mixed.encodedHost)
	}

	// MARK: Complex

	@Test func percentEncoding() throws {
		// Setting properties with allowed characters.
		var allowedCharactersComponents = URLComponents(
			scheme: TestStrings.allowed.scheme,
			user: TestStrings.allowed.user,
			password: TestStrings.allowed.password,
			host: TestStrings.allowed.host,
			path: TestStrings.allowed.path,
			query: TestStrings.allowed.query,
			fragment: TestStrings.allowed.fragment
		)
		try allowedCharactersComponents
			.assertHasPercentEncoding(false)
			.assertEquals(strings: TestStrings.allowed)
		allowedCharactersComponents.normalizePercentEncoding()
		try allowedCharactersComponents
			.assertHasPercentEncoding(false)
			.assertEquals(strings: TestStrings.allowed)

		// Setting properties with mixed characters.
		var mixedCharactersComponents = URLComponents(
			scheme: TestStrings.mixed.scheme,
			user: TestStrings.mixed.user,
			password: TestStrings.mixed.password,
			host: TestStrings.mixed.host,
			path: TestStrings.mixed.path,
			query: TestStrings.mixed.query,
			fragment: TestStrings.mixed.fragment
		)
		try mixedCharactersComponents
			.assertHasPercentEncoding()
			.assertEquals(strings: TestStrings.mixed)
			.assertEquals(percentEncodedStrings: TestStrings.mixed, encodingColon: false)
		mixedCharactersComponents.normalizePercentEncoding()
		try mixedCharactersComponents
			.assertHasPercentEncoding()
			.assertEquals(strings: TestStrings.mixed)
			.assertEquals(percentEncodedStrings: TestStrings.mixed, encodingColon: false)
	}

	@Test func manualPercentEncoding() throws {
		// Setting percent-encoded properties with encoded mixed characters (colon not encoded for user and password components).
		var manuallyEncodedComponentsExcludingColon = try URLComponents.percentEncoded(
			scheme: TestStrings.mixed.scheme,
			user: TestStrings.mixed.percentEncodedUserExcludingColon,
			password: TestStrings.mixed.percentEncodedPasswordExcludingColon,
			host: TestStrings.mixed.encodedHost,
			path: #require(TestStrings.mixed.percentEncodedPath),
			query: TestStrings.mixed.percentEncodedQuery,
			fragment: TestStrings.mixed.percentEncodedFragment
		)
		try manuallyEncodedComponentsExcludingColon
			.assertHasPercentEncoding()
			.assertEquals(strings: TestStrings.mixed)
			.assertEquals(percentEncodedStrings: TestStrings.mixed, encodingColon: false)
		manuallyEncodedComponentsExcludingColon.normalizePercentEncoding()
		try manuallyEncodedComponentsExcludingColon
			.assertHasPercentEncoding()
			.assertEquals(strings: TestStrings.mixed)
			.assertEquals(percentEncodedStrings: TestStrings.mixed, encodingColon: false)

		// Setting percent-encoded properties with encoded mixed characters.
		var manuallyEncodedComponents = try URLComponents.percentEncoded(
			scheme: TestStrings.mixed.scheme,
			user: TestStrings.mixed.percentEncodedUser,
			password: TestStrings.mixed.percentEncodedPassword,
			host: TestStrings.mixed.encodedHost,
			path: #require(TestStrings.mixed.percentEncodedPath),
			query: TestStrings.mixed.percentEncodedQuery,
			fragment: TestStrings.mixed.percentEncodedFragment
		)
		try manuallyEncodedComponents
			.assertHasPercentEncoding()
			.assertEquals(strings: TestStrings.mixed)
			.assertEquals(percentEncodedStrings: TestStrings.mixed, encodingColon: true)
		manuallyEncodedComponents.normalizePercentEncoding()
		try manuallyEncodedComponents
			.assertHasPercentEncoding()
			.assertEquals(strings: TestStrings.mixed)
			.assertEquals(percentEncodedStrings: TestStrings.mixed, encodingColon: true)

		// Setting percent-encoded properties with all-encoded mixed characters.
		var allEncoded = try URLComponents.percentEncoded(
			scheme: TestStrings.mixed.scheme,
			user: TestStrings.mixed.user?.percentEncoded,
			password: TestStrings.mixed.password?.percentEncoded,
			host: TestStrings.mixed.host?.percentEncoded,
			path: #require(TestStrings.mixed.path.percentEncoded),
			query: TestStrings.mixed.query?.percentEncoded,
			fragment: TestStrings.mixed.fragment?.percentEncoded
		)
		try allEncoded
			.assertHasPercentEncoding()
			.assertEquals(strings: TestStrings.mixed)
		allEncoded.normalizePercentEncoding()
		try allEncoded
			.assertHasPercentEncoding()
			.assertEquals(strings: TestStrings.mixed)
			.assertEquals(percentEncodedStrings: TestStrings.mixed, encodingColon: true)
	}

}
