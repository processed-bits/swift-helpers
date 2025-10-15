// Data+Extensions.swift, 28.12.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation

/// Creating and inspecting data using set bit indices.
public extension Data {

	// MARK: Creating Populated Data

	/// Creates data with specified bit indices set to 1.
	///
	/// - Parameters:
	///   - indices: The indices of the bits equal to 1.
	///   - minByteCount: The minimum number of bytes the data contains.
	///
	/// The indices and the minimum number of bytes (if any) must be nonnegative. Otherwise, `fatalError` is called.
	///
	/// The size of the data is the largest of:
	///
	/// - the number of bytes required to represent the bit with the largest index;
	/// - the minimum number of bytes, if specified.
	///
	/// The size of the data is practically limited by platform and memory constraints. Trying to initialize unreasonably large `Data` objects could lead to undefined behavior or a runtime error.
	init(nonzeroBits indices: [Int], minByteCount: Int? = nil) {
		guard !indices.contains(where: { $0 < 0 }) else {
			fatalError("Indices must be nonnegative.")
		}
		if let minByteCount {
			guard minByteCount >= 0 else {
				fatalError("`minByteCount` must be greater than or equal to zero.")
			}
		}

		// If there are no indices, return empty or zeroed data, depending on `minByteCount`.
		guard let maxIndex = indices.max() else {
			self.init(count: minByteCount ?? 0)
			return
		}

		// Calculate the number of bytes.
		let requiredBitCount = UInt(maxIndex) + 1
		let (quotient, remainder) = requiredBitCount.quotientAndRemainder(dividingBy: UInt(Element.bitWidth))
		let requiredByteCount = Int(quotient + (remainder > 0 ? 1 : 0))
		let byteCount = Swift.max(requiredByteCount, minByteCount ?? 0)

		self.init(count: byteCount)

		// Set the bits.
		for index in indices {
			let byteIndex = index / Element.bitWidth
			let bitPosition = index % Element.bitWidth
			self[byteIndex] |= 1 << bitPosition
		}
	}

	// MARK: Inspecting Bits

	/// The indices of the bits equal to 1.
	var nonzeroBits: [Int] {
		var indices: [Int] = []

		for (byteIndex, byte) in enumerated() {
			// Skip the byte if no bits are set.
			guard byte != 0 else {
				continue
			}

			for bitPosition in 0 ..< Element.bitWidth {
				let bit = (byte >> bitPosition) & 1
				guard bit == 1 else {
					continue
				}

				let index = byteIndex * Element.bitWidth + bitPosition
				indices.append(index)
			}
		}

		return indices
	}

}
