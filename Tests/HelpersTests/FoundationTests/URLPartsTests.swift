// URLPartsTests.swift, 05.04.2024-14.12.2024.
// Copyright © 2024 Stanislav Lomachinskiy.

import Foundation
import Testing

private extension URL {
	@discardableResult func assertLastPathComponent(expected: String, sourceLocation: SourceLocation = #_sourceLocation) throws -> Self {
		#expect(lastPathComponent == expected, sourceLocation: sourceLocation)
		return self
	}

	@discardableResult func assertStem(expected: String?, sourceLocation: SourceLocation = #_sourceLocation) throws -> Self {
		#expect(stem == expected, sourceLocation: sourceLocation)
		return self
	}
}

struct URLPartsTests {

	@Test func lastPathComponent() throws {
		try URL(requireString: "foo.zip").assertLastPathComponent(expected: "foo.zip")
		try URL(requireString: "foo.tar.gz").assertLastPathComponent(expected: "foo.tar.gz")
		try URL(requireString: "/tmp/foo.txt").assertLastPathComponent(expected: "foo.txt")
		try URL(requireString: "Xcode.app/").assertLastPathComponent(expected: "Xcode.app")
		try URL(requireString: "/Applications/Xcode.app/").assertLastPathComponent(expected: "Xcode.app")

		try URL(requireString: ".hidden").assertLastPathComponent(expected: ".hidden")
		try URL(requireString: "/tmp/.hidden").assertLastPathComponent(expected: ".hidden")

		try URL(requireString: ".").assertLastPathComponent(expected: ".")
		try URL(requireString: "/tmp/.").assertLastPathComponent(expected: ".")

		try URL(requireString: "..").assertLastPathComponent(expected: "..")
		try URL(requireString: "/tmp/..").assertLastPathComponent(expected: "..")

		try URL(requireString: "/").assertLastPathComponent(expected: "/")
		try URL(requireString: "https://github.com").assertLastPathComponent(expected: "")
	}

	@Test func stem() throws {
		try URL(requireString: "foo.zip").assertStem(expected: "foo")
		try URL(requireString: "foo.tar.gz").assertStem(expected: "foo.tar")
		try URL(requireString: "/tmp/foo.txt").assertStem(expected: "foo")
		try URL(requireString: "Xcode.app/").assertStem(expected: "Xcode")
		try URL(requireString: "/Applications/Xcode.app/").assertStem(expected: "Xcode")

		try URL(requireString: ".hidden").assertStem(expected: ".hidden")
		try URL(requireString: "/tmp/.hidden").assertStem(expected: ".hidden")

		try URL(requireString: ".").assertStem(expected: ".")
		try URL(requireString: "..").assertStem(expected: "..")
		try URL(requireString: "/tmp/.").assertStem(expected: ".")
		try URL(requireString: "/tmp/..").assertStem(expected: "..")

		try URL(requireString: "/").assertStem(expected: "/")
		try URL(requireString: "https://github.com").assertStem(expected: nil)

		try URL(filePath: "foo.zip").assertStem(expected: "foo")
		try URL(filePath: "foo.tar.gz").assertStem(expected: "foo.tar")
		try URL(filePath: "/tmp/foo.txt").assertStem(expected: "foo")

		try URL(filePath: ".hidden").assertStem(expected: ".hidden")
		try URL(filePath: "/tmp/.hidden").assertStem(expected: ".hidden")

		try URL(filePath: "Xcode.app").assertStem(expected: "Xcode")
		try URL(filePath: "Xcode.app/").assertStem(expected: "Xcode")
		try URL(filePath: "/Applications/Xcode.app/").assertStem(expected: "Xcode")

		try URL(filePath: "/tmp/.").assertStem(expected: ".")
		try URL(filePath: "/tmp/..").assertStem(expected: "..")

		try URL(filePath: "/").assertStem(expected: "/")
		try URL(filePath: #"\"#).assertStem(expected: #"\"#)
	}

}
