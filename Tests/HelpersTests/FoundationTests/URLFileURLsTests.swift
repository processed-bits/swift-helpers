// URLFileURLsTests.swift, 05.04.2024-14.02.2025.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation
import Helpers
import Testing

private extension URL {
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, visionOS 1.0, watchOS 9.0, *)
	@discardableResult func assertExpandingTildeInPath(_ expected: Bool = true, sourceLocation: SourceLocation = #_sourceLocation) -> Self {
		let expandedURL = expandingTildeInPath
		let expandedPath = expandedURL.path(percentEncoded: false)
		let homePath = URL.homeDirectory.path(percentEncoded: false)
		#expect(expandedPath.starts(with: homePath) == expected, sourceLocation: sourceLocation)
		return expandedURL
	}
}

struct URLFileURLsTests {

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, visionOS 1.0, watchOS 9.0, *)
	@Test func expandingTildeInPath() throws {
		// Directory URLs.
		URL(filePath: "~").assertExpandingTildeInPath()
		URL(filePath: "~/").assertExpandingTildeInPath()
		URL(filePath: "~/Downloads/").assertExpandingTildeInPath()

		// Non-directory URLs.
		URL(filePath: "~/File").assertExpandingTildeInPath()

		// Invalid URLs.
		URL(filePath: "~/Downloads/~").assertExpandingTildeInPath(false)
		URL(filePath: "~/Downloads/~/").assertExpandingTildeInPath(false)
		try URL(requireString: "~").assertExpandingTildeInPath(false)
		try URL(requireString: "~/").assertExpandingTildeInPath(false)
	}

}
