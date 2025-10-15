// URLEncodingTests.swift, 31.12.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation
import FoundationHelpers
import Testing

// MARK: - Assertions

private extension URLComponents {
	/// Asserts that the URL components (scheme, user, password, host, path, query, and fragment) equal respective test strings.
	@discardableResult func assertEquals(
		strings: URLTestStrings,
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		#expect(scheme == strings.scheme, sourceLocation: sourceLocation)
		#expect(user == strings.user, sourceLocation: sourceLocation)
		#expect(password == strings.password, sourceLocation: sourceLocation)
		#expect(host == strings.host, sourceLocation: sourceLocation)
		#expect(path == strings.path, sourceLocation: sourceLocation)
		#expect(query == strings.query, sourceLocation: sourceLocation)
		#expect(fragment == strings.fragment, sourceLocation: sourceLocation)
		return self
	}
}

// MARK: - Tests

/// Tests URL components (user, password, host, path, query, and fragment) for percent-encoding and case preservation, where applicable.
///
/// - Host accepts percent-encoding, but IDNA encoding is mostly used.
/// - Host may be transformed to lowercase by the `encodedHost` setter.
/// - User and password `URLComponents` plain setters do not encode the colon (`:`) on macOS 15 and Linux.
/// - Path does not encode the semicolon (`;`) on macOS 13.
///
/// RFC 3986: URI producing applications must not use percent-encoding in host unless it is used to represent a UTF-8 character sequence. URI producers should provide these registered names in the IDNA encoding, rather than a percent-encoding, if they wish to maximize interoperability with legacy URI resolvers.
struct URLEncodingTests {

	// MARK: User and Password

	/// Character sets `urlUserAllowed` and `urlPasswordAllowed` do not contain a colon (`:`), and it should be percent-encoded.
	@Test func userPasswordColonEncoding() throws {
		#expect(CharacterSet.urlUserAllowed.contains(":") == false)
		#expect(CharacterSet.urlPasswordAllowed.contains(":") == false)
		#expect(":".encoded(with: .urlUserAllowed) == "%3A")
		#expect(":".encoded(with: .urlPasswordAllowed) == "%3A")
	}

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func userPasswordEncoding() throws {
		// `URLComponents` plain setters.
		var components = URLComponents(
			scheme: "https",
			user: "a:b",
			password: "c:d",
			host: "host"
		)

		#expect(components.user == "a:b")
		#expect(components.password == "c:d")
		withKnownIssue(.urlEncodingUserPasswordColon) {
			#expect(components.percentEncodedUser == "a%3Ab")
			#expect(components.percentEncodedPassword == "c%3Ad")
			#expect(components.string == "https://a%3Ab:c%3Ad@host")
		} when: {
			Condition.isMacOS15 || Condition.isLinux
		}

		components.normalizePercentEncoding()

		// Components with a known issue should pass the test after normalization.
		#expect(components.percentEncodedUser == "a%3Ab")
		#expect(components.percentEncodedPassword == "c%3Ad")
		#expect(components.string == "https://a%3Ab:c%3Ad@host")

		// `URLComponents` percent-encoded setters.
		components = URLComponents.encoded(
			scheme: "https",
			user: "a%3Ab",
			password: "c%3Ad",
			host: "host"
		)

		#expect(components.user == "a:b")
		#expect(components.password == "c:d")
		#expect(components.percentEncodedUser == "a%3Ab")
		#expect(components.percentEncodedPassword == "c%3Ad")
		#expect(components.string == "https://a%3Ab:c%3Ad@host")

		// `URLComponents` string initializer.
		components = try URLComponents(requireString: "https://a%3Ab:c%3Ad@host")

		#expect(components.user == "a:b")
		#expect(components.password == "c:d")
		#expect(components.percentEncodedUser == "a%3Ab")
		#expect(components.percentEncodedPassword == "c%3Ad")
		#expect(components.string == "https://a%3Ab:c%3Ad@host")

		// `URL` string initializer.
		let url = try URL(requireString: "https://a%3Ab:c%3Ad@host")

		#expect(url.user(percentEncoded: false) == "a:b")
		#expect(url.password(percentEncoded: false) == "c:d")
		#expect(url.user(percentEncoded: true) == "a%3Ab")
		#expect(url.password(percentEncoded: true) == "c%3Ad")
		#expect(url.absoluteString == "https://a%3Ab:c%3Ad@host")
	}

	// MARK: Host

	/// Tests percent-encoding using `encodedHost` and deprecated `percentEncodedHost` properties, and using a string initializer.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func hostEncoding() throws {
		let host = "café.example.com"
		let percentEncodedHost = try #require(host.encoded(with: .urlHostAllowed))
		let overEncodedHost = try #require(host.encoded())

		#expect(host != percentEncodedHost)
		#expect(percentEncodedHost != overEncodedHost)

		var components = URLComponents()
		components.scheme = "https"

		// Using `encodedHost` property.
		// Percent-encoded host.
		components.encodedHost = percentEncodedHost
		#expect(components.host == host)
		#expect(components.encodedHost == percentEncodedHost)
		// Over-encoded host.
		components.encodedHost = overEncodedHost
		#expect(components.host == host)
		#expect(components.encodedHost == overEncodedHost)

		// Using deprecated `percentEncodedHost` property.
		// Percent-encoded host.
		components.percentEncodedHost = percentEncodedHost
		#expect(components.host == host)
		#expect(components.percentEncodedHost == percentEncodedHost)
		// Over-encoded host.
		components.percentEncodedHost = overEncodedHost
		#expect(components.host == host)
		withKnownIssue(.urlEncodingHost) {
			#expect(components.percentEncodedHost == overEncodedHost)
		}

		// Using string initializer.
		// Percent-encoded host.
		components = try URLComponents(requireString: "https://" + percentEncodedHost)
		#expect(components.host == host)
		#expect(components.encodedHost == percentEncodedHost)
		// Over-encoded host.
		components = try URLComponents(requireString: "https://" + overEncodedHost)
		#expect(components.host == host)
		#expect(components.encodedHost == overEncodedHost)
	}

	// MARK: Allowed Characters

	/// Tests absence of percent-encoding of URL components created with allowed test strings, using plain properties.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func allowedCharacters() throws {
		let strings = URLTestStrings.allowed
		var components = strings.components

		components.assertEquals(strings: strings)
		#expect(components.percentEncodedUser == strings.encodedUserRFC)
		#expect(components.percentEncodedPassword == strings.encodedPasswordRFC)
		#expect(components.encodedHost == strings.encodedHostRFC)
		withKnownIssue(.urlEncodingPathSemicolon) {
			#expect(components.percentEncodedPath == strings.encodedPathRFC)
		} when: {
			Condition.isMacOS13
		}
		// Test alternative expectation for a known issue.
		if Condition.isMacOS13 {
			#expect(components.percentEncodedPath == strings.encodedPath)
		}
		#expect(components.percentEncodedQuery == strings.encodedQueryRFC)
		#expect(components.percentEncodedFragment == strings.encodedFragmentRFC)

		components.normalizePercentEncoding()

		components.assertEquals(strings: strings)
		#expect(components.percentEncodedUser == strings.encodedUserRFC)
		#expect(components.percentEncodedPassword == strings.encodedPasswordRFC)
		#expect(components.encodedHost == strings.encodedHostRFC)
		#expect(components.percentEncodedPath == strings.encodedPathRFC)
		#expect(components.percentEncodedQuery == strings.encodedQueryRFC)
		#expect(components.percentEncodedFragment == strings.encodedFragmentRFC)
	}

	/// Tests absence of percent-encoding of URL components created with allowed test strings, using encoded properties, encoded according to RFC 3986.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func allowedEncodedCharacters() throws {
		let strings = URLTestStrings.allowed
		var components = try strings.rfcEncodedComponents()

		components.assertEquals(strings: strings)
		#expect(components.percentEncodedUser == strings.encodedUserRFC)
		#expect(components.percentEncodedPassword == strings.encodedPasswordRFC)
		#expect(components.encodedHost == strings.encodedHostRFC)
		#expect(components.percentEncodedPath == strings.encodedPathRFC)
		#expect(components.percentEncodedQuery == strings.encodedQueryRFC)
		#expect(components.percentEncodedFragment == strings.encodedFragmentRFC)

		components.normalizePercentEncoding()

		components.assertEquals(strings: strings)
		#expect(components.percentEncodedUser == strings.encodedUserRFC)
		#expect(components.percentEncodedPassword == strings.encodedPasswordRFC)
		#expect(components.encodedHost == strings.encodedHostRFC)
		#expect(components.percentEncodedPath == strings.encodedPathRFC)
		#expect(components.percentEncodedQuery == strings.encodedQueryRFC)
		#expect(components.percentEncodedFragment == strings.encodedFragmentRFC)
	}

	// MARK: Mixed Characters

	/// Tests percent-encoding of URL components created with mixed test strings, using plain properties.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func mixedCharacters() throws {
		let strings = URLTestStrings.mixed
		var components = strings.components

		components.assertEquals(strings: strings)
		withKnownIssue(.urlEncodingUserPasswordColon) {
			#expect(components.percentEncodedUser == strings.encodedUserRFC)
			#expect(components.percentEncodedPassword == strings.encodedPasswordRFC)
		} when: {
			Condition.isMacOS15 || Condition.isLinux
		}
		// Test alternative expectation for a known issue.
		if Condition.isMacOS15 || Condition.isLinux {
			#expect(components.percentEncodedUser == strings.user?.encoded(
				with: .urlUserAllowedRFC3986.union(.init(charactersIn: ":"))
			))
			#expect(components.percentEncodedPassword == strings.password?.encoded(
				with: .urlPasswordAllowedRFC3986.union(.init(charactersIn: ":"))
			))
		}
		#expect(components.encodedHost == strings.encodedHostRFC)
		withKnownIssue(.urlEncodingPathSemicolon) {
			#expect(components.percentEncodedPath == strings.encodedPathRFC)
		} when: {
			Condition.isMacOS13
		}
		// Test alternative expectation for a known issue.
		if Condition.isMacOS13 {
			#expect(components.percentEncodedPath == strings.encodedPath)
		}
		#expect(components.percentEncodedQuery == strings.encodedQueryRFC)
		#expect(components.percentEncodedFragment == strings.encodedFragmentRFC)

		components.normalizePercentEncoding()

		components.assertEquals(strings: strings)
		#expect(components.percentEncodedUser == strings.encodedUserRFC)
		#expect(components.percentEncodedPassword == strings.encodedPasswordRFC)
		#expect(components.encodedHost == strings.encodedHostRFC)
		#expect(components.percentEncodedPath == strings.encodedPathRFC)
		#expect(components.percentEncodedQuery == strings.encodedQueryRFC)
		#expect(components.percentEncodedFragment == strings.encodedFragmentRFC)
	}

	/// Tests percent-encoding of URL components created with mixed test strings, using encoded properties, encoded according to RFC 3986.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func mixedEncodedCharacters() throws {
		let strings = URLTestStrings.mixed
		var components = try strings.rfcEncodedComponents()

		components.assertEquals(strings: strings)
		#expect(components.percentEncodedUser == strings.encodedUserRFC)
		#expect(components.percentEncodedPassword == strings.encodedPasswordRFC)
		#expect(components.encodedHost == strings.encodedHostRFC)
		#expect(components.percentEncodedPath == strings.encodedPathRFC)
		#expect(components.percentEncodedQuery == strings.encodedQueryRFC)
		#expect(components.percentEncodedFragment == strings.encodedFragmentRFC)

		components.normalizePercentEncoding()

		components.assertEquals(strings: strings)
		#expect(components.percentEncodedUser == strings.encodedUserRFC)
		#expect(components.percentEncodedPassword == strings.encodedPasswordRFC)
		#expect(components.encodedHost == strings.encodedHostRFC)
		#expect(components.percentEncodedPath == strings.encodedPathRFC)
		#expect(components.percentEncodedQuery == strings.encodedQueryRFC)
		#expect(components.percentEncodedFragment == strings.encodedFragmentRFC)
	}

	/// Tests percent-encoding of URL components created with mixed test strings, using encoded properties, fully encoded.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func mixedOverEncodedCharacters() throws {
		let strings = URLTestStrings.mixed
		var components = try strings.overEncodedComponents()

		components.assertEquals(strings: strings)
		#expect(components.percentEncodedUser == strings.user?.encoded())
		#expect(components.percentEncodedPassword == strings.password?.encoded())
		#expect(components.encodedHost == strings.host?.encoded())
		#expect(components.percentEncodedPath == strings.path.encoded())
		#expect(components.percentEncodedQuery == strings.query?.encoded())
		#expect(components.percentEncodedFragment == strings.fragment?.encoded())

		components.normalizePercentEncoding()

		components.assertEquals(strings: strings)
		#expect(components.percentEncodedUser == strings.encodedUserRFC)
		#expect(components.percentEncodedPassword == strings.encodedPasswordRFC)
		#expect(components.encodedHost == strings.encodedHostRFC)
		#expect(components.percentEncodedPath == strings.encodedPathRFC)
		#expect(components.percentEncodedQuery == strings.encodedQueryRFC)
		#expect(components.percentEncodedFragment == strings.encodedFragmentRFC)
	}

}
