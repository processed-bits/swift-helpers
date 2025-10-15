// CollectionTests.swift, 19.08.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import StandardLibraryHelpers
import Testing

struct CollectionTests {

	@Test func nilIfEmpty() {
		// Arrays.
		let array = ["Test"]
		let emptyArray: [String] = []
		#expect(array.nilIfEmpty == array)
		#expect(emptyArray.nilIfEmpty == nil)

		// Strings.
		let string = "Test"
		let emptyString = ""
		#expect(string.nilIfEmpty == Optional.some(string))
		#expect(emptyString.nilIfEmpty == nil)

		// Substrings.
		let substring = Substring(string)
		let emptySubstring = Substring(emptyString)
		#expect(substring.nilIfEmpty == Optional.some(substring))
		#expect(emptySubstring.nilIfEmpty == nil)
	}

	@Test func joinedOptionals() {
		let someStrings = ["A", nil, "B", "C", nil]
		let noStrings: [String?] = [nil, nil]
		#expect(someStrings.joined() == "ABC")
		#expect(noStrings.joined() == nil)
	}

}
