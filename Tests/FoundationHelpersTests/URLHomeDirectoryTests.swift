// URLHomeDirectoryTests.swift, 05.04.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

import Foundation
import FoundationHelpers
import Testing

private extension URL {
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@discardableResult func assertExpandingHomeDirectory(
		_ expectedPath: String,
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		let expandedURL = expandingHomeDirectory
		let expandedPath = expandedURL.path(percentEncoded: false)

		#expect(expandedPath == expectedPath, sourceLocation: sourceLocation)
		return self
	}
}

struct URLHomeDirectoryTests {

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func expandingHomeDirectory() throws {
		let userName = ProcessInfo.processInfo.userName
		let homeDirectoryURL = URL.homeDirectory
		let homePath = homeDirectoryURL.path(percentEncoded: false)

		try URL.assertInitialized(string: "~")
			.assertExpandingHomeDirectory(homePath)
		try URL.assertInitialized(string: "~/")
			.assertExpandingHomeDirectory(homePath)
		try URL.assertInitialized(string: "~/.gitconfig")
			.assertExpandingHomeDirectory("\(homePath).gitconfig")
		try URL.assertInitialized(string: "~/Downloads/")
			.assertExpandingHomeDirectory("\(homePath)Downloads/")

		try URL.assertInitialized(string: "~\(userName)")
			.assertExpandingHomeDirectory(homePath)
		try URL.assertInitialized(string: "~\(userName)/")
			.assertExpandingHomeDirectory(homePath)
		try URL.assertInitialized(string: "~\(userName)/.gitconfig")
			.assertExpandingHomeDirectory("\(homePath).gitconfig")
		try URL.assertInitialized(string: "~\(userName)/Downloads/")
			.assertExpandingHomeDirectory("\(homePath)Downloads/")

		withKnownIssue(.urlInitFilePathHomeDirectoryExpansion) {
			URL.assertInitialized(filePath: "~")
				.assertExpandingHomeDirectory(homePath)
			URL.assertInitialized(filePath: "~")
				.assertExpandingHomeDirectory(homePath)
			URL.assertInitialized(filePath: "~/")
				.assertExpandingHomeDirectory(homePath)
			URL.assertInitialized(filePath: "~/.gitconfig")
				.assertExpandingHomeDirectory("\(homePath).gitconfig")
			URL.assertInitialized(filePath: "~/Downloads/")
				.assertExpandingHomeDirectory("\(homePath)Downloads/")

			URL.assertInitialized(filePath: "~\(userName)")
				.assertExpandingHomeDirectory(homePath)
			URL.assertInitialized(filePath: "~\(userName)/")
				.assertExpandingHomeDirectory(homePath)
			URL.assertInitialized(filePath: "~\(userName)/.gitconfig")
				.assertExpandingHomeDirectory("\(homePath).gitconfig")
			URL.assertInitialized(filePath: "~\(userName)/Downloads/")
				.assertExpandingHomeDirectory("\(homePath)Downloads/")
		} when: {
			Condition.isLinux
		}

		// Invalid tilde position.
		try URL.assertInitialized(string: "/tmp/~")
			.assertExpandingHomeDirectory("/tmp/~")
		URL.assertInitialized(filePath: "/tmp/~")
			.assertExpandingHomeDirectory("/tmp/~")

		// Invalid username.
		#if os(Linux)
			try withKnownIssue(.urlInitFilePathHomeDirectoryExpansion) {
				try URL.assertInitialized(string: "~nonexistentuser")
					.assertExpandingHomeDirectory("/var/empty/")
			} when: {
				Condition.isCompiler6_1
			}
			try withKnownIssue(.urlInitFilePathHomeDirectoryExpansion) {
				try URL.assertInitialized(filePath: "~nonexistentuser")
					.assertExpandingHomeDirectory("/var/empty/")
			}
		#else
			try URL.assertInitialized(string: "~nonexistentuser")
				.assertExpandingHomeDirectory("~nonexistentuser")
			URL.assertInitialized(filePath: "~nonexistentuser")
				.assertExpandingHomeDirectory("~nonexistentuser")
		#endif
	}

}
