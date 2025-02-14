// CharacterSetTests.swift, 28.12.2024-03.01.2025.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation
import Testing

struct CharacterSetTests {

	@Test func bitmapFromNonzeroBits() throws {
		let value = 88
		let scalar = try #require(Unicode.Scalar(value))
		#expect(scalar.value == value)

		let bitmapRepresentation = Data(nonzeroBits: [value])
		let set = CharacterSet(bitmapRepresentation: bitmapRepresentation)
		#expect(set.scalars == [scalar])
	}

	@Test func printCharacters() throws {
		let sets: KeyValuePairs<CharacterSet, String> = [
			.urlUserAllowed: "urlUserAllowed",
			.urlPasswordAllowed: "urlPasswordAllowed",
			.urlHostAllowed: "urlHostAllowed",
			.urlPathAllowed: "urlPathAllowed",
			.urlQueryAllowed: "urlQueryAllowed",
			.urlFragmentAllowed: "urlFragmentAllowed",
		]

		for (set, setName) in sets {
			let string = String(set.scalars)

			print("CharacterSet.\(setName):")
			print(string)
			print()
		}
	}

}
