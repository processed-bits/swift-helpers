// URLDirectoryTests.swift, 17.05.2022-15.02.2025.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import Foundation
import Testing

private extension URL {
	@discardableResult func assertHasDirectoryPath(_ expected: Bool = true, sourceLocation: SourceLocation = #_sourceLocation) -> Self {
		#expect(hasDirectoryPath == expected, sourceLocation: sourceLocation)
		return self
	}
}

struct URLDirectoryTests {

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, visionOS 1.0, watchOS 9.0, *)
	@Test func fileHasDirectoryPath() throws {
		// URLs with directory references.
		URL(filePath: "").assertHasDirectoryPath()
		URL(filePath: "/").assertHasDirectoryPath()
		URL(filePath: "./").assertHasDirectoryPath()
		URL(filePath: "Folder/").assertHasDirectoryPath()
		URL(filePath: "/Folder/").assertHasDirectoryPath()

		// URLs with files references.
		URL(filePath: "File").assertHasDirectoryPath(false)
		URL(filePath: "/File").assertHasDirectoryPath(false)

		// URL paths ending in `.` are initialized as file references.
		URL(filePath: ".").assertHasDirectoryPath(false)
		URL(filePath: "/.").assertHasDirectoryPath(false)
		URL(filePath: "Folder/.").assertHasDirectoryPath(false)
		URL(filePath: "/Folder/.").assertHasDirectoryPath(false)

		URL(filePath: "./").assertHasDirectoryPath()
		URL(filePath: "/./").assertHasDirectoryPath()
		URL(filePath: "Folder/./").assertHasDirectoryPath()
		URL(filePath: "/Folder/./").assertHasDirectoryPath()

		// URL paths ending in `..` are resolved as file references.
		URL(filePath: "..").assertHasDirectoryPath(false)
		URL(filePath: "/..").assertHasDirectoryPath(false)
		URL(filePath: "Folder/..").assertHasDirectoryPath(false)
		URL(filePath: "/Folder/..").assertHasDirectoryPath(false)

		URL(filePath: "../").assertHasDirectoryPath()
		URL(filePath: "/../").assertHasDirectoryPath()
		URL(filePath: "Folder/../").assertHasDirectoryPath()
		URL(filePath: "/Folder/../").assertHasDirectoryPath()
	}

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

}
