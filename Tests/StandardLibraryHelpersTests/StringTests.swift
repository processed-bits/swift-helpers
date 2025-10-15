// StringTests.swift, 23.11.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import StandardLibraryHelpers
import Testing

struct StringTests {

	private let string = "Mary had a little lamb, his fleece was white as snow"

	// MARK: Truncating

	@Test func longTruncation() {
		let truncatedString = string.truncated(to: 99)
		#expect(truncatedString == string)
	}

	@Test func shortTruncation() {
		for length in 0 ... String.defaultTruncationTerminator.count {
			let truncatedString = string.truncated(to: length)
			let prefixedString = String(string.prefix(length))
			#expect(truncatedString == prefixedString)
		}
	}

	@Test func removingCharactersTruncation() throws {
		let commaIndex = try #require(string.firstIndex(of: ","), "String does not contain a `,`.")
		let truncationLength = string.distance(from: string.startIndex, to: commaIndex) + String.defaultTruncationTerminator.count

		// Removing extra characters.
		for length in truncationLength ... truncationLength + 2 {
			let truncatedString = string.truncated(to: length)
			#expect(truncatedString == "Mary had a little lamb…")
		}

		// Not removing extra characters.
		let truncatedString = string.truncated(to: truncationLength - 1)
		#expect(truncatedString == "Mary had a little lam…")
	}

}
