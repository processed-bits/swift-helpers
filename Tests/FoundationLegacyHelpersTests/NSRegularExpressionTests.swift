// NSRegularExpressionTests.swift, 20.08.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import Foundation
import FoundationLegacyHelpers
import Testing

struct NSRegularExpressionTests {

	@Test func matchingStrings() throws {
		let string = "abc"
		let pattern = "[a-z]"
		let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
		#expect(regex ~= string)
		#expect(regex.numberOfMatches(in: string) == 3)
		#expect(regex.matches(in: string).count == 3)
		#expect(regex.firstMatch(in: string) != nil)
	}

	@Test func nonMatchingStrings() throws {
		let string = "abc"
		let pattern = "[0-9]"
		let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
		#expect(!(regex ~= string))
		#expect(regex.numberOfMatches(in: string) == 0)
		#expect(regex.matches(in: string).isEmpty)
		#expect(regex.firstMatch(in: string) == nil)
	}

	@Test func enumeratingMatches() throws {
		let string = "abc"
		let pattern = "[b0]"
		let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
		var rangeOfFirstMatch: Range<String.Index>?
		regex.enumerateMatches(in: string) { result, _, _ in
			guard let result else {
				return
			}
			rangeOfFirstMatch = result.range(in: string)
			#expect(result.range(in: string) == string.range(of: "b"))
		}
		#expect(rangeOfFirstMatch == regex.rangeOfFirstMatch(in: string))
	}

}
