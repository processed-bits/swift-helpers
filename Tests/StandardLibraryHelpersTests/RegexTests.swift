// RegexTests.swift, 12.11.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import StandardLibraryHelpers
import Testing

struct RegexTests {

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func matchingStrings() throws {
		let string = "abc"
		let regex = /[a-z]/.ignoresCase()
		#expect(regex ~= string)
		#expect(string.matches(of: regex).count == 3)
		#expect(string.firstMatch(of: regex) != nil)
	}

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func nonMatchingStrings() throws {
		let string = "abc"
		let regex = /[0-9]/.ignoresCase()
		#expect(!(regex ~= string))
		#expect(string.matches(of: regex).isEmpty)
		#expect(string.firstMatch(of: regex) == nil)
	}

}
