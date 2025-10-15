// KeyValuePairsTests.swift, 07.02.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

import StandardLibraryHelpers
import Testing

struct KeyValuePairsTests {

	@Test func formatted() throws {
		let pairs: KeyValuePairs = [
			"Katie": 3,
			"Amy": 2,
			"Michelle": 4,
		]

		// Formatted strings and expected first lines.
		let stringsAndExpectations: KeyValuePairs = [
			pairs.formatted():
				"Katie    3",
			pairs.formatted(keySuffix: ":"):
				"Katie:    3",
			pairs.formatted(keyValueSeparator: " → "):
				"Katie    → 3",
			pairs.formatted(maxKeyLength: 4):
				"Kat… 3",
			pairs.formatted(maxKeyLength: 4, keySuffix: ":"):
				"Kat…: 3",
			pairs.formatted(maxKeyLength: 4, keyValueSeparator: " → "):
				"Kat… → 3",
		]

		for (string, expected) in stringsAndExpectations {
			print(string)
			// Take the first line for comparison.
			let result = string.prefix { $0 != "\n" }
			#expect(result == expected)
		}
	}

}
