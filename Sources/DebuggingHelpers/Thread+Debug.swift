// Thread+Debug.swift, 12.01.2021.
// Copyright © 2021-2025 Stanislav Lomachinskiy.

import Foundation

public extension Thread {

	/// The thread’s number from its description.
	var number: Int? {
		Self.number(from: description)
	}

	/// The thread’s memory address from its description.
	var memoryAddress: String? {
		Self.memoryAddress(from: description)
	}

	/// Returns a number from a provided thread’s description.
	static func number(from description: String) -> Int? {
		guard let startIndex = description.range(of: "number = ")?.upperBound,
		      let endIndex = description[startIndex...].firstIndex(of: ",") else {
			return nil
		}
		let result = description[startIndex ..< endIndex]
		return Int(result)
	}

	/// Returns a memory address from a provided thread’s description.
	static func memoryAddress(from description: String) -> String? {
		guard let hexPrefixRange = description.range(of: "0x") else {
			return nil
		}

		var endIndex = hexPrefixRange.upperBound
		while endIndex < description.endIndex, description[endIndex].isHexDigit {
			endIndex = description.index(after: endIndex)
		}
		let resultRange = hexPrefixRange.lowerBound ..< endIndex

		let result = description[resultRange]
		return String(result)
	}

}
