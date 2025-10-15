// CharacterSetTests.swift, 28.12.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation
import FoundationHelpers
import StandardLibraryHelpers
import Testing

struct CharacterSetTests {

	// MARK: URL Encoding

	@Test func printURLCharacterSets() throws {
		let setsAndLabels: KeyValuePairs<String, CharacterSet> = [
			"urlUserAllowed": .urlUserAllowed,
			"urlPasswordAllowed": .urlPasswordAllowed,
			"urlHostAllowed": .urlHostAllowed,
			"urlPathAllowed": .urlPathAllowed,
			"urlQueryAllowed": .urlQueryAllowed,
			"urlFragmentAllowed": .urlFragmentAllowed,
		]
		let longestLabel = setsAndLabels.map(\.0.count).max()

		var output = "System URL allowed character sets:"
		for (label, set) in setsAndLabels {
			let characters = String(set.scalars)
			let pair: KeyValuePairs = [label: characters]
			output += "\n" + pair.formatted(maxKeyLength: longestLabel, keySuffix: ":")
		}
		print(output)
	}

	/// Tests URL allowed character sets for differences against RFC 3986.
	///
	/// - `urlPathAllowed` does not include a semicolon (`;`) on macOS 13 and Linux.
	@Test func urlCharacterSets() throws {
		// swiftlint:disable:next large_tuple
		typealias TestSet = (label: String, systemSet: CharacterSet, rfcSet: CharacterSet)
		let sets: [TestSet] = [
			("urlUserAllowed", .urlUserAllowed, .urlUserAllowedRFC3986),
			("urlPasswordAllowed", .urlPasswordAllowed, .urlPasswordAllowedRFC3986),
			("urlHostAllowed", .urlHostAllowed, .urlHostAllowedRFC3986),
			("urlPathAllowed", .urlPathAllowed, .urlPathAllowedRFC3986),
			("urlQueryAllowed", .urlQueryAllowed, .urlQueryAllowedRFC3986),
			("urlFragmentAllowed", .urlFragmentAllowed, .urlFragmentAllowedRFC3986),
		]
		let longestLabel = sets.map(\.0.count).max()

		var output = "System vs RFC 3986 URL allowed character sets difference:"
		for (label, systemSet, rfcSet) in sets {
			withKnownIssue(.characterSetURLPathAllowedSemicolon) {
				#expect(systemSet == rfcSet)
			} when: {
				label == "urlPathAllowed" && (Condition.isMacOS13 || Condition.isLinux)
			}

			let difference = systemSet.symmetricDifference(rfcSet)
			lazy var characters = String(difference.scalars)
			let value = difference.isEmpty ? "nil" : characters
			let pair: KeyValuePairs = [label: value]
			output += "\n" + pair.formatted(maxKeyLength: longestLabel, keySuffix: ":")
		}
		print(output)
	}

	// MARK: Scalars

	@Test func bitmapFromNonzeroBits() throws {
		let value = 88
		let scalar = try #require(Unicode.Scalar(value))
		#expect(scalar.value == value)

		let bitmapRepresentation = Data(nonzeroBits: [value])
		let set = CharacterSet(bitmapRepresentation: bitmapRepresentation)
		#expect(set.scalars == [scalar])
	}

}
