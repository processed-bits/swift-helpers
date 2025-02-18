// URLFilenameComponentsTests.swift, 25.12.2024-15.02.2025.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation
import Helpers
import Testing

private extension URL {
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, visionOS 1.0, watchOS 9.0, *)
	@discardableResult func assertFilenameComponents(expected: FilenameComponents?, sourceLocation: SourceLocation = #_sourceLocation) throws -> Self {
		#expect(filenameComponents == expected, sourceLocation: sourceLocation)

		// If expectation is not `nil`, check a URL recreated from file components against self.
		if expected != nil, let filenameComponents {
			let recreatedURL = filenameComponents.url
			#expect(recreatedURL == self, sourceLocation: sourceLocation)
		}

		return self
	}
}

struct URLFilenameComponentsTests {

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, visionOS 1.0, watchOS 9.0, *)
	@Test func filenameComponents() throws {
		// String URL, non-directory reference.
		try URL(requireString: "scp:/private/tmp/resource").assertFilenameComponents(expected:
			.init(directoryString: "scp:/private/tmp/", "resource")
		)
		// String URL, directory reference.
		try URL(requireString: "scp:/private/tmp/").assertFilenameComponents(expected:
			.init(directoryString: "scp:/private/", "tmp", isDirectory: true)
		)

		// File URL, non-directory reference.
		try URL(filePath: "/tmp/.hidden").assertFilenameComponents(expected:
			.init(directoryFilePath: "/tmp/", ".hidden")
		)
		try URL(filePath: "/tmp/.hidden.").assertFilenameComponents(expected:
			.init(directoryFilePath: "/tmp/", ".hidden", "")
		)
		// File URL, directory reference.
		try URL(filePath: "/Applications/Xcode.app/").assertFilenameComponents(expected:
			.init(directoryFilePath: "/Applications/", "Xcode", "app", isDirectory: true)
		)
		withKnownIssue("Directory URL doesn't represent a directory path.") {
			try URL(filePath: "/Applications/Xcode.app/").assertFilenameComponents(expected:
				.init(directoryFilePath: "/Applications", "Xcode", "app", isDirectory: true)
			)
		}

		// No stem.
		try URL(requireString: "file:").assertFilenameComponents(expected: nil)
		try URL(requireString: "file://").assertFilenameComponents(expected: nil)
		try URLComponents(scheme: "file").requireURL().assertFilenameComponents(expected: nil)
		try URLComponents(path: "").requireURL().assertFilenameComponents(expected: nil)
	}

}
