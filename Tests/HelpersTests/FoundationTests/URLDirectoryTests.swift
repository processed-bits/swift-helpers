// URLDirectoryTests.swift, 17.05.2022-21.12.2024.
// Copyright © 2022-2024 Stanislav Lomachinskiy.

import Foundation
import Testing

private extension URL {
	@discardableResult func assertHasDirectoryPath(_ expected: Bool = true, sourceLocation: SourceLocation = #_sourceLocation) -> Self {
		#expect(hasDirectoryPath == expected, sourceLocation: sourceLocation)
		return self
	}
}

struct URLDirectoryTests {

	@Test func hasDirectoryPath() throws {
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
