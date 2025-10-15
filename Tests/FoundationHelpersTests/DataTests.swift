// DataTests.swift, 29.12.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation
import FoundationHelpers
import Testing

private extension Data {
	@discardableResult func assertCount(
		_ expected: Int,
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		let result = count
		#expect(result == expected, sourceLocation: sourceLocation)
		return self
	}

	@discardableResult func assertNonzeroBits(
		_ expected: [Int],
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		let result = nonzeroBits
		#expect(result == expected, sourceLocation: sourceLocation)
		return self
	}

	@discardableResult func assert(_ closure: (Self) -> Bool, sourceLocation: SourceLocation = #_sourceLocation) -> Self {
		#expect(closure(self))
		return self
	}
}

struct DataTests {

	@Test func initNonzeroBits() throws {
		// No bits, no byte count.
		Data(nonzeroBits: [])
			.assertNonzeroBits([])
			.assertCount(0)

		// No bits, set byte count.
		Data(nonzeroBits: [], minByteCount: 2)
			.assertNonzeroBits([])
			.assertCount(2)

		// Set bits, no byte count.
		Data(nonzeroBits: [0])
			.assertNonzeroBits([0])
			.assertCount(1)
			.assert { $0.first == 0b0000_0001 }
		Data(nonzeroBits: [7])
			.assertNonzeroBits([7])
			.assertCount(1)
			.assert { $0.first == 0b1000_0000 }

		// Set bits, set byte count.
		Data(nonzeroBits: [16], minByteCount: 0)
			.assertNonzeroBits([16])
			.assertCount(3)
			.assert { $0.last == 0b0000_0001 }
		Data(nonzeroBits: [0], minByteCount: 1_024)
			.assertNonzeroBits([0])
			.assertCount(1_024)
			.assert { $0.first == 0b0000_0001 }
	}

}
