// URLLexicalNormalizationTests.swift, 17.04.2024-01.02.2025.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation
import Helpers
import Testing

private typealias Test = NormalizationTest

struct URLLexicalNormalizationTests {

	private let baseString = "https://a/b/c"
	private let basePath = "/a/b/c"

	// MARK: Current Directory

	@Test func currentDirectoryOnly() throws {
		try Test(string: ".", expected: "")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: ".", resolve: false, expected: "")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "./", expected: "")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "./", resolve: false, expected: "")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "/.", expected: "/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "/.", expected: "/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "/./", expected: "/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "/./", expected: "/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
	}

	@Test func currentDirectoryLeading() throws {
		try Test(string: "./x", expected: "x")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "./x", resolve: false, expected: "x")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "./x/", expected: "x/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "./x/", resolve: false, expected: "x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "/./x", expected: "/x")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "/./x", expected: "/x")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "/./x/", expected: "/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "/./x/", expected: "/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
	}

	@Test func currentDirectoryTrailing() throws {
		try Test(string: "x/.", expected: "x/")
			.assertLexicallyNormalized()
			.assertStandardized()
		withKnownIssue("Relative file URL paths with `/.` suffix are initialized as non-directory references.") {
			try Test(filePath: "x/.", resolve: false, expected: "x/")
				.assertLexicallyNormalized()
				.assertStandardized()
				.assertLexicallyNormalizedFilePath()
		}

		try Test(string: "x/./", expected: "x/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "x/./", resolve: false, expected: "x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "/x/.", expected: "/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "/x/.", expected: "/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "/x/./", expected: "/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "/x/./", expected: "/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
	}

	@Test func currentDirectoryOnlyResolving() throws {
		try Test(string: ".", relativeTo: baseString, expected: "https://a/b/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: ".", relativeTo: basePath, expected: "/a/b/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "./", relativeTo: baseString, expected: "https://a/b/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "./", relativeTo: basePath, expected: "/a/b/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
	}

	@Test func currentDirectoryLeadingResolving() throws {
		try Test(string: "./x", relativeTo: baseString, expected: "https://a/b/x")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "./x", relativeTo: basePath, expected: "/a/b/x")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "./x/", relativeTo: baseString, expected: "https://a/b/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "./x/", relativeTo: basePath, expected: "/a/b/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
	}

	@Test func currentDirectoryTrailingResolving() throws {
		try Test(string: "x/.", relativeTo: baseString, expected: "https://a/b/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
		withKnownIssue("Relative file URL paths with `/.` suffix are initialized as non-directory references.") {
			try Test(filePath: "x/.", relativeTo: basePath, expected: "/a/b/x/")
				.assertLexicallyNormalized()
				.assertStandardized()
				.assertStandardizedFile()
				.assertLexicallyNormalizedFilePath()
		}

		try Test(string: "x/./", relativeTo: baseString, expected: "https://a/b/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "x/./", relativeTo: basePath, expected: "/a/b/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
	}

	// MARK: Parent Directory

	@Test func parentDirectoryOnly() throws {
		try Test(string: "..", expected: "..")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "..", resolve: false, expected: "..")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "../", expected: "../")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "../", resolve: false, expected: "../")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "/..", expected: "/")
			.dump()
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "/..", expected: "/")
			.dump()
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "/../", expected: "/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "/../", expected: "/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
	}

	@Test func parentDirectoryLeading() throws {
		try Test(string: "../x", expected: "../x")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "../x", resolve: false, expected: "../x")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "../x/", expected: "../x/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "../x/", resolve: false, expected: "../x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "/../x", expected: "/x")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "/../x", expected: "/x")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "/../x/", expected: "/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "/../x/", expected: "/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
	}

	@Test func parentDirectoryTrailing() throws {
		try Test(string: "x/..", expected: "")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "x/..", resolve: false, expected: "")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "x/../", expected: "")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "x/../", resolve: false, expected: "")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "x/y/..", expected: "x/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "x/y/..", resolve: false, expected: "x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "x/y/../", expected: "x/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "x/y/../", resolve: false, expected: "x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "/x/..", expected: "/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "/x/..", expected: "/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "/x/../", expected: "/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "/x/../", expected: "/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "/x/y/..", expected: "/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "/x/y/..", expected: "/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "/x/y/../", expected: "/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "/x/y/../", expected: "/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
	}

	@Test func parentDirectoryOnlyResolving() throws {
		try Test(string: "..", relativeTo: baseString, expected: "https://a/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "..", relativeTo: basePath, expected: "/a/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "../", relativeTo: baseString, expected: "https://a/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "../", relativeTo: basePath, expected: "/a/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
	}

	@Test func parentDirectoryLeadingResolving() throws {
		try Test(string: "../x", relativeTo: baseString, expected: "https://a/x")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "../x", relativeTo: basePath, expected: "/a/x")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "../x/", relativeTo: baseString, expected: "https://a/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "../x/", relativeTo: basePath, expected: "/a/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
	}

	@Test func parentDirectoryTrailingResolving() throws {
		try Test(string: "x/..", relativeTo: baseString, expected: "https://a/b/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "x/..", relativeTo: basePath, expected: "/a/b/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()

		try Test(string: "x/../", relativeTo: baseString, expected: "https://a/b/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(filePath: "x/../", relativeTo: basePath, expected: "/a/b/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
	}

	// MARK: Relative References

	@Test func relativeReferences() throws {
//		let baseString = "https://host/a/b"

		// Network-path reference.
		try Test(string: "//x", relativeTo: baseString, expected: "https://x")
			.assertLexicallyNormalized()
			.assertStandardized()
		// Absolute-path reference.
		try Test(string: "/x", relativeTo: baseString, expected: "https://a/x")
			.assertLexicallyNormalized()
			.assertStandardized()
		// Relative-path reference.
		try Test(string: "x", relativeTo: baseString, expected: "https://a/b/x")
			.assertLexicallyNormalized()
			.assertStandardized()
		// Same-document reference.
		try Test(string: "#x", relativeTo: baseString, expected: "https://a/b/c#x")
			.assertLexicallyNormalized()
			.assertStandardized()
	}

	// MARK: Colon in Path

	@Test func colonInPath() throws {
		try Test(path: "x:y", expected: "./x:y")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "./x:y", expected: "./x:y")
			.assertLexicallyNormalized()
			.assertStandardized()
	}

	// MARK: Empty Path Components

	@Test func emptyPathComponents() throws {
		try Test(string: "https://example.com//", expected: "https://example.com//")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "https://example.com//a/", expected: "https://example.com//a/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "https://example.com/a//", expected: "https://example.com/a//")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "https://example.com/a//b", expected: "https://example.com/a//b")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "https://example.com/a//b/", expected: "https://example.com/a//b/")
			.assertLexicallyNormalized()
			.assertStandardized()

		try Test(string: "https://example.com//", removeEmptyPathComponents: true, expected: "https://example.com/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "https://example.com//a/", removeEmptyPathComponents: true, expected: "https://example.com/a/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "https://example.com/a//", removeEmptyPathComponents: true, expected: "https://example.com/a/")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "https://example.com/a//b", removeEmptyPathComponents: true, expected: "https://example.com/a/b")
			.assertLexicallyNormalized()
			.assertStandardized()
		try Test(string: "https://example.com/a//b/", removeEmptyPathComponents: true, expected: "https://example.com/a/b/")
			.assertLexicallyNormalized()
			.assertStandardized()

		try Test(filePath: "//private/tmp/", expected: "//private/tmp/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
		try Test(filePath: "/private//tmp/", expected: "/private//tmp/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
		try Test(filePath: "/private/tmp//", expected: "/private/tmp//")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()

		try Test(filePath: "//private/tmp/", removeEmptyPathComponents: true, expected: "/private/tmp/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
		try Test(filePath: "/private//tmp/", removeEmptyPathComponents: true, expected: "/private/tmp/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
		try Test(filePath: "/private/tmp//", removeEmptyPathComponents: true, expected: "/private/tmp/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
	}

	// MARK: Complex

	@Test func complex() throws {
		// Relative paths.
		try Test(filePath: "./x/./y/..", resolve: false, expected: "x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()
		try Test(filePath: "./x/./y/../", resolve: false, expected: "x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(filePath: "../../x/./y/./", resolve: false, expected: "../../x/y/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(filePath: "../x/./y/z", resolve: false, expected: "../x/y/z")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(filePath: "../x/./y/./z", resolve: false, expected: "../x/y/z")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(filePath: "../../x/./y/z", resolve: false, expected: "../../x/y/z")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(filePath: "x/./y/", resolve: false, expected: "x/y/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		withKnownIssue("Relative file URL paths with `/.` suffix are initialized as non-directory references.") {
			try Test(filePath: "x/./y/.", resolve: false, expected: "x/y/")
				.assertLexicallyNormalized()
				.assertStandardized()
				.assertLexicallyNormalizedFilePath()
		}
		try Test(filePath: "x/./y/./", resolve: false, expected: "x/y/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		try Test(filePath: "x/./y/z", resolve: false, expected: "x/y/z")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()

		// Absolute paths.
		try Test(filePath: "/./x/.", expected: "/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
		try Test(filePath: "/./x/./", expected: "/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()

		try Test(filePath: "/x/./y/..", expected: "/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()
		try Test(filePath: "/x/./y/../", expected: "/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertLexicallyNormalizedFilePath()
	}

	@Test func complexResolving() throws {
		try Test(filePath: "x/..", relativeTo: "/a/b/c", expected: "/a/b/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
		try Test(filePath: "x/../", relativeTo: "/a/b/c", expected: "/a/b/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()

		try Test(filePath: "x/y/..", relativeTo: "/a/b/../c", expected: "/a/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
		try Test(filePath: "x/y/../", relativeTo: "/a/b/../c", expected: "/a/x/")
			.assertLexicallyNormalized()
			.assertStandardized()
			.assertStandardizedFile()
			.assertLexicallyNormalizedFilePath()
	}

}
