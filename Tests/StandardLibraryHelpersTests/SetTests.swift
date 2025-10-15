// SetTests.swift, 19.08.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import StandardLibraryHelpers
import Testing

struct SetTests {

	@Test func initFromString() {
		let set1 = Set(from: "A|B|C", separator: "|")
		let set2 = Set(from: "A, B, C", separator: ",")
		let set3 = Set(from: "A, B, C", separator: ",", trimCharacters: nil)
		let expectedSet = Set(["A", "B", "C"])
		#expect(set1 == expectedSet)
		#expect(set2 == expectedSet)
		#expect(set3 != expectedSet)
	}

}
