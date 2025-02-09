// KeyValuePairsTests.swift, 07.02.2025-08.02.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

import Testing

struct KeyValuePairsTests {

	@Test func formatted() throws {
		let pairs: KeyValuePairs = [
			"Katie": 3,
			"Amy": 2,
			"Michelle": 3,
		]

		// Formatted strings and expected first lines.
		let stringsAndExpectations: KeyValuePairs = [
			pairs.formatted(): "Katie    3",
			pairs.formatted(keySuffix: ":"): "Katie:    3",
			pairs.formatted(keyValueSeparator: " → "): "Katie    → 3",
			pairs.formatted(maxKeyLength: 4): "Kat… 3",
			pairs.formatted(maxKeyLength: 4, keySuffix: ":"): "Kat…: 3",
			pairs.formatted(maxKeyLength: 4, keyValueSeparator: " → "): "Kat… → 3",
		]

		for (string, expected) in stringsAndExpectations {
			print(string)
			defer { print() }

			let result = string.prefix { $0 != "\n" }
			#expect(result == expected)
		}
	}

}
