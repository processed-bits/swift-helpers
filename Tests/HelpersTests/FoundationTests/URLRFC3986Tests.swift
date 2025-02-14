// URLRFC3986Tests.swift, 17.04.2024-30.01.2025.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation
import Helpers
import Testing

private typealias Test = NormalizationTest

/// RFC 3986 [Section 5.4](https://datatracker.ietf.org/doc/html/rfc3986#section-5.4) examples tests.
///
/// The URL type does not fully resolve some abnormal examples (tested as absolute strings). Tests that lexically normalized URLs return the expected results. Also tests URL `standardized` property.
struct URLRFC3986Tests {
	// swiftlint:disable force_https

	private let baseString = "http://a/b/c/d;p?q"

	// MARK: Normal

	@Test func normalExamples() throws {
		try Test(string: "g:h", relativeTo: baseString, expected: "g:h")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "g", relativeTo: baseString, expected: "http://a/b/c/g")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "./g", relativeTo: baseString, expected: "http://a/b/c/g")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "g/", relativeTo: baseString, expected: "http://a/b/c/g/")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "/g", relativeTo: baseString, expected: "http://a/g")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "//g", relativeTo: baseString, expected: "http://g")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "?y", relativeTo: baseString, expected: "http://a/b/c/d;p?y")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "g?y", relativeTo: baseString, expected: "http://a/b/c/g?y")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "#s", relativeTo: baseString, expected: "http://a/b/c/d;p?q#s")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "g#s", relativeTo: baseString, expected: "http://a/b/c/g#s")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "g?y#s", relativeTo: baseString, expected: "http://a/b/c/g?y#s")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: ";x", relativeTo: baseString, expected: "http://a/b/c/;x")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "g;x", relativeTo: baseString, expected: "http://a/b/c/g;x")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "g;x?y#s", relativeTo: baseString, expected: "http://a/b/c/g;x?y#s")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(path: "", relativeTo: URL(requireString: baseString), expected: "http://a/b/c/d;p?q")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: ".", relativeTo: baseString, expected: "http://a/b/c/")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "./", relativeTo: baseString, expected: "http://a/b/c/")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "..", relativeTo: baseString, expected: "http://a/b/")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "../", relativeTo: baseString, expected: "http://a/b/")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "../g", relativeTo: baseString, expected: "http://a/b/g")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "../..", relativeTo: baseString, expected: "http://a/")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "../../", relativeTo: baseString, expected: "http://a/")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "../../g", relativeTo: baseString, expected: "http://a/g")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
	}

	// MARK: Abnormal

	@Test func abnormalExamples() throws {
		try Test(string: "../../../g", relativeTo: baseString, expected: "http://a/g")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "../../../../g", relativeTo: baseString, expected: "http://a/g")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()

		try Test(string: "/./g", relativeTo: baseString, expected: "http://a/g")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "/../g", relativeTo: baseString, expected: "http://a/g")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "g.", relativeTo: baseString, expected: "http://a/b/c/g.")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: ".g", relativeTo: baseString, expected: "http://a/b/c/.g")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "g..", relativeTo: baseString, expected: "http://a/b/c/g..")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "..g", relativeTo: baseString, expected: "http://a/b/c/..g")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()

		try Test(string: "./../g", relativeTo: baseString, expected: "http://a/b/g")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "./g/.", relativeTo: baseString, expected: "http://a/b/c/g/")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "g/./h", relativeTo: baseString, expected: "http://a/b/c/g/h")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "g/../h", relativeTo: baseString, expected: "http://a/b/c/h")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "g;x=1/./y", relativeTo: baseString, expected: "http://a/b/c/g;x=1/y")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "g;x=1/../y", relativeTo: baseString, expected: "http://a/b/c/y")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()

		try Test(string: "g?y/./x", relativeTo: baseString, expected: "http://a/b/c/g?y/./x")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "g?y/../x", relativeTo: baseString, expected: "http://a/b/c/g?y/../x")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "g#s/./x", relativeTo: baseString, expected: "http://a/b/c/g#s/./x")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "g#s/../x", relativeTo: baseString, expected: "http://a/b/c/g#s/../x")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()

		try Test(string: "http:g", relativeTo: baseString, expected: "http:g")
			.assertAbsoluteString()
			.assertLexicallyNormalized()
			.assertStandardized()
	}

	// swiftlint:enable force_https
}
