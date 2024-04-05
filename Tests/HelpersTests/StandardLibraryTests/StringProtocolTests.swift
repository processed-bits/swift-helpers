// StringProtocolTests.swift, 18.08.2022-05.04.2024.
// Copyright © 2022-2024 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class StringProtocolTests: XCTestCase {

	private let string = "Mary had a little lamb, his fleece was white as snow"

	// MARK: Changing Case

	func testCaseConversion() {
		let locale = Locale(identifier: "de_DE")
		// Lowercase.
		XCTAssertEqual("SS test".lowercasedFirstLetter, "sS test")
		XCTAssertEqual("SS test".lowercasedFirstLetter(with: locale), "sS test")
		XCTAssertEqual("SS test".localizedLowercasedFirstLetter, "sS test")
		// Uppercase.
		XCTAssertEqual("ß test".uppercasedFirstLetter, "SS test")
		XCTAssertEqual("ß test".uppercasedFirstLetter(with: locale), "SS test")
		XCTAssertEqual("ß test".localizedUppercasedFirstLetter, "SS test")
	}

	// MARK: Padding

	func testComparePadding() {
		for length in 0 ... 99 {
			let standardPaddedString = string.padding(toLength: length, withPad: ".", startingAt: 0)
			let paddedString = string.padding(toLength: length, withPad: ".")
			XCTAssertEqual(paddedString, standardPaddedString)
		}
	}

	func testLeadingPadding() {
		for length in 0 ... 99 {
			let paddedString = string.padding(toLength: length, padSide: .leading)
			XCTAssertEqual(paddedString.count, length)
		}
	}

	// MARK: Trimming

	func testTrimmed() {
		let string = " Test "
		let substring = Substring(string)
		XCTAssertEqual(string.trimmed, "Test")
		XCTAssertEqual(substring.trimmed, "Test")
	}

}
