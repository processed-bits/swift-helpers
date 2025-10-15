// URLLexicalNormalizationTests.swift, 17.04.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

#if canImport(System)
	import Foundation
	import Testing

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	private typealias Test = URLNormalizationTest

	struct URLLexicalNormalizationTests {

		private let baseString = "https://a/b/c"
		private let basePath = "/a/b/c"

		// MARK: Current Directory

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
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

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
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

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
		@Test func currentDirectoryTrailing() throws {
			try Test(string: "x/.", expected: "x/")
				.assertLexicallyNormalized()
				.assertStandardized()
			try withKnownIssue(.urlInitRelativeFilePathTransformation) {
				try Test(filePath: "x/.", resolve: false, expected: "x/")
					.assertLexicallyNormalized()
					.assertStandardized()
					.assertLexicallyNormalizedFilePath()
			} when: {
				!Condition.isLinux
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

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
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

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
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

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
		@Test func currentDirectoryTrailingResolving() throws {
			try Test(string: "x/.", relativeTo: baseString, expected: "https://a/b/x/")
				.assertLexicallyNormalized()
				.assertStandardized()
			try withKnownIssue(.urlInitRelativeFilePathTransformation) {
				try Test(filePath: "x/.", relativeTo: basePath, expected: "/a/b/x/")
					.assertLexicallyNormalized()
					.assertStandardized()
					.assertStandardizedFile()
					.assertLexicallyNormalizedFilePath()
			} when: {
				!Condition.isLinux
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

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
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
				.assertLexicallyNormalized()
				.assertStandardized()
			try Test(filePath: "/..", expected: "/")
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

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
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

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
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

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
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

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
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

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
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

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
		@Test func relativeReferences() throws {
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

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
		@Test func colonInPath() throws {
			try Test(path: "x:y", expected: "./x:y")
				.assertLexicallyNormalized()
				.assertStandardized()
			try Test(string: "./x:y", expected: "./x:y")
				.assertLexicallyNormalized()
				.assertStandardized()
		}

		// MARK: Empty Path Components

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
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

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
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

			try withKnownIssue(.urlInitRelativeFilePathTransformation) {
				try Test(filePath: "x/./y/.", resolve: false, expected: "x/y/")
					.assertLexicallyNormalized()
					.assertStandardized()
					.assertLexicallyNormalizedFilePath()
			} when: {
				!Condition.isLinux
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

		@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
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
#endif
