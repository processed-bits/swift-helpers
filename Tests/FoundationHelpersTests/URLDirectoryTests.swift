// URLDirectoryTests.swift, 17.05.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import Foundation
import Testing

private extension URL {
	@discardableResult func assertHasDirectoryPath(
		_ expected: Bool = true,
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		#expect(hasDirectoryPath == expected, sourceLocation: sourceLocation)
		return self
	}

	@discardableResult func assertHasSingleTrailingPathSeparator(
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		let path = path(percentEncoded: false)
		let singleTrailingPathSeparator = #/[^/]/$/#
		#expect(path.firstMatch(of: singleTrailingPathSeparator) != nil, sourceLocation: sourceLocation)
		return self
	}
}

struct URLDirectoryTests {

	@Test func stringHasDirectoryPath() throws {
		try URL(requireString: "/").assertHasDirectoryPath()
		try URL(requireString: "./").assertHasDirectoryPath()
		try URL(requireString: "path/").assertHasDirectoryPath()
		try URL(requireString: "/path/").assertHasDirectoryPath()

		try URL(requireString: "path").assertHasDirectoryPath(false)
		try URL(requireString: "/path").assertHasDirectoryPath(false)

		try URL(requireString: "https://github.com/").assertHasDirectoryPath()
		try URL(requireString: "https://github.com/apple/").assertHasDirectoryPath()

		try URL(requireString: "https://github.com").assertHasDirectoryPath(false)
		try URL(requireString: "https://github.com/apple").assertHasDirectoryPath(false)
	}

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func fileHasDirectoryPath() throws {
		// URLs with directory references.
		URL(filePath: "").assertHasDirectoryPath()
		URL(filePath: "/").assertHasDirectoryPath()
		URL(filePath: "./").assertHasDirectoryPath()
		URL(filePath: "Folder/").assertHasDirectoryPath()
		URL(filePath: "/Folder/").assertHasDirectoryPath()

		// URLs with file references.
		URL(filePath: "File").assertHasDirectoryPath(false)
		URL(filePath: "/File").assertHasDirectoryPath(false)

		#if os(Linux)
			URL(filePath: ".").assertHasDirectoryPath(true)
		#else
			URL(filePath: ".").assertHasDirectoryPath(false)
		#endif
		URL(filePath: "/.").assertHasDirectoryPath(false)
		#if os(Linux)
			URL(filePath: "Folder/.").assertHasDirectoryPath(true)
		#else
			URL(filePath: "Folder/.").assertHasDirectoryPath(false)
		#endif
		URL(filePath: "/Folder/.").assertHasDirectoryPath(false)

		URL(filePath: "./").assertHasDirectoryPath()
		URL(filePath: "/./").assertHasDirectoryPath()
		URL(filePath: "Folder/./").assertHasDirectoryPath()
		URL(filePath: "/Folder/./").assertHasDirectoryPath()

		#if os(Linux)
			URL(filePath: "..").assertHasDirectoryPath(true)
		#else
			URL(filePath: "..").assertHasDirectoryPath(false)
		#endif
		URL(filePath: "/..").assertHasDirectoryPath(false)
		#if os(Linux)
			URL(filePath: "Folder/..").assertHasDirectoryPath(true)
		#else
			URL(filePath: "Folder/..").assertHasDirectoryPath(false)
		#endif
		URL(filePath: "/Folder/..").assertHasDirectoryPath(false)

		URL(filePath: "../").assertHasDirectoryPath()
		URL(filePath: "/../").assertHasDirectoryPath()
		URL(filePath: "Folder/../").assertHasDirectoryPath()
		URL(filePath: "/Folder/../").assertHasDirectoryPath()
	}

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test(arguments: [
		URL(string: "path"),
		URL(string: "/path"),
		URL(filePath: "Folder"),
		URL(filePath: "/Folder"),
	])
	func makeDirectoryPath(url: URL?) throws {
		let url = try #require(url)
		url.assertHasDirectoryPath(false)

		url.appending(path: "")
			.assertHasDirectoryPath()
			.assertHasSingleTrailingPathSeparator()

		url.appending(component: "")
			.assertHasDirectoryPath()
			.assertHasSingleTrailingPathSeparator()
	}

}
