// URLHomeDirectoryTests.swift, 05.04.2024.
// Copyright © 2024 Stanislav Lomachinskiy.

import XCTest

final class URLHomeDirectoryTests: XCTestCase {

	func testExpandingTildeInPath() throws {
		let homeURL = URL.homeDirectory
		let directoryURLs = [
			URL(filePath: "~"),
			URL(filePath: "~", directoryHint: .isDirectory),
			URL(filePath: "~/"),
			URL(filePath: "~/Downloads", directoryHint: .isDirectory),
			URL(filePath: "~/Downloads/"),
		]
		for url in directoryURLs {
			let expandedURL = url.expandingTildeInPath
			XCTAssertTrue(expandedURL.path(percentEncoded: false).starts(with: homeURL.path(percentEncoded: false)))
			XCTAssertTrue(expandedURL.hasDirectoryPath)
		}

		let fileURLs = [
			URL(filePath: "~/file"),
			URL(filePath: "~/file/", directoryHint: .notDirectory),
		]
		for url in fileURLs {
			let expandedURL = url.expandingTildeInPath
			XCTAssertTrue(expandedURL.path(percentEncoded: false).starts(with: homeURL.path(percentEncoded: false)))
			XCTAssertFalse(expandedURL.hasDirectoryPath)
		}

		let invalidURLs = try [
			URL(filePath: "~/Downloads/~"),
			URL(filePath: "~/Downloads/~/"),
			XCTUnwrap(URL(string: "~")),
			XCTUnwrap(URL(string: "~/")),
		]
		for url in invalidURLs {
			XCTAssertEqual(url, url.expandingTildeInPath)
		}
	}

}
