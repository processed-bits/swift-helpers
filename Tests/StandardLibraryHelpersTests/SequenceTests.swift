// SequenceTests.swift, 19.08.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import StandardLibraryHelpers
import Testing

struct SequenceTests {

	@Test func compacted() {
		#expect(["A", nil, "B", "C", nil].compacted() == ["A", "B", "C"])
		#expect([1, nil, 2, 3, nil].compacted() == [1, 2, 3])
	}

}
