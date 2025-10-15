// StringProtocolTests.swift, 18.08.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import Foundation
import StandardLibraryHelpers
import Testing

struct StringProtocolTests {

	private let string = "Mary had a little lamb, his fleece was white as snow"

	// MARK: Changing Case

	@Test func caseConversion() {
		let locale = Locale(identifier: "de_DE")

		// Lowercase.
		#expect("SS test".lowercasedFirstLetter == "sS test")
		#expect("SS test".lowercasedFirstLetter(with: locale) == "sS test")
		#expect("SS test".localizedLowercasedFirstLetter == "sS test")

		// Uppercase.
		#expect("ß test".uppercasedFirstLetter == "SS test")
		#expect("ß test".uppercasedFirstLetter(with: locale) == "SS test")
		#expect("ß test".localizedUppercasedFirstLetter == "SS test")
	}

	// MARK: Padding

	@Test func comparePadding() {
		for length in 0 ... 99 {
			let standardPaddedString = string.padding(toLength: length, withPad: ".", startingAt: 0)
			let paddedString = string.padding(toLength: length, withPad: ".")
			#expect(paddedString == standardPaddedString)
		}
	}

	@Test func leadingPadding() {
		for length in 0 ... 99 {
			let paddedString = string.padding(toLength: length, padSide: .leading)
			#expect(paddedString.count == length)
		}
	}

	// MARK: Trimming

	@Test func trimmed() {
		let string = " Test "
		let substring = Substring(string)
		#expect(string.trimmed == "Test")
		#expect(substring.trimmed == "Test")
	}

}
