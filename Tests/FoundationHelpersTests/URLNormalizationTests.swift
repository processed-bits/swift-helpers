// URLNormalizationTests.swift, 17.04.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

#if canImport(System)
	import Foundation
	import FoundationHelpers
	import Testing

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	private typealias Test = URLNormalizationTest

	struct URLNormalizationTests {

		// MARK: Host

		/// Tests host case and percent-encoding normalization.
		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
		@Test func host() throws {
			let abnormalHost = "eXAMPLE.com"
			let normalizedHost = abnormalHost.lowercased()

			// All characters encoded, percent-encoding triplets have A-F letters lowercased.
			let abnormalEncodedHost = try #require(abnormalHost.addingPercentEncoding(withAllowedCharacters: .empty)).lowercased()

			let url = try URL(requireString: "https://" + abnormalEncodedHost)
			// Host component will have the plain string.
			#expect(url.host == abnormalHost)
			// String representation will have the encoded string.
			#expect(url.absoluteString.contains(abnormalEncodedHost))

			// Normalized URL will be lowercased and have percent-encoding removed.
			let normalizedURL = try #require(url.normalized())
			#expect(url != normalizedURL)
			#expect(normalizedURL.host == normalizedHost)
			#expect(normalizedURL.absoluteString.contains(normalizedHost))
		}

		// MARK: Empty Path

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
		@Test func emptyPath() throws {
			// Non-empty host.
			try Test(string: "https://server.remote", expected: "https://server.remote/")
				.assertNormalized()
				.assertStandardized()
			try Test(string: "https://server.remote/", expected: "https://server.remote/")
				.assertNormalized()
				.assertStandardized()

			// Non-empty host, no scheme.
			try Test(string: "//server.remote", expected: "//server.remote/")
				.assertNormalized()
				.assertStandardized()
			try Test(string: "//server.remote/", expected: "//server.remote/")
				.assertNormalized()
				.assertStandardized()
		}

		// MARK: Case-Insensitive Path

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
		@Test func caseInsensitivePath() throws {
			try Test(string: "MailTo:John.Appleseed@apple.com", lowercasePath: true, expected: "mailto:john.appleseed@apple.com")
				.assertNormalized()
				.assertStandardized()
		}

		// MARK: Base

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
		@Test func base() throws {
			let string = "x/../y/./z"
			let baseString = "HTTPS://eXAMPLE.com/./a/../b/c"

			// Test normalization.
			try Test(string: string, relativeTo: baseString, resolve: false, expected: "y/z")
				.assertNormalized()
				.assertStandardized()
			try Test(string: string, relativeTo: baseString, resolve: true, expected: "https://example.com/b/y/z")
				.assertNormalized()
				.assertStandardized()

			// Test base URL after normalization.
			let url = try URL(requireString: string, relativeTo: baseString)
			let normalizedResolvedURL = try #require(url.normalized(resolvingAgainstBaseURL: true))
			let normalizedNonResolvedURL = try #require(url.normalized(resolvingAgainstBaseURL: false))
			let standardizedURL = url.standardized
			#expect(normalizedResolvedURL.baseURL == nil)
			#expect(normalizedNonResolvedURL.baseURL?.absoluteString == baseString)
			#expect(standardizedURL.baseURL?.absoluteString == baseString)
		}

		// MARK: Complex

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
		@Test func complex() throws {
			// Scheme, path.
			try Test(string: "File://a/./b/../b/%63/%7bfoo%7d", expected: "file://a/b/c/%7Bfoo%7D")
				.assertNormalized()
				.assertStandardized()

			// Host, path.
			try Test(string: "https://%65%58%41%4d%50%4c%45%2e%63%6f%6d", expected: "https://example.com/")
				.assertNormalized()
				.assertStandardized()

			// Port, path.
			try Test(string: "https://apple.com:", expected: "https://apple.com/")
				.assertNormalized()
				.assertStandardized()
			try Test(string: "https://apple.com:443", expected: "https://apple.com/")
				.assertNormalized()
				.assertStandardized()

			// Query.
			try Test(string: "https://github.com/apple/swift/issues?q=is%3Aopen", expected: "https://github.com/apple/swift/issues?q=is:open")
				.assertNormalized()
				.assertStandardized()
		}

	}
#endif
