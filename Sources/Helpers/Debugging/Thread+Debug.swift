// Thread+Debug.swift, 12.01.2021-16.11.2022.
// Copyright © 2021-2022 Stanislav Lomachinskiy.

import Foundation

public extension Thread {

	/// The thread number from the description.
	var number: Int? {
		guard let startIndex = description.range(of: "number = ")?.upperBound,
		      let endIndex = description[startIndex...].firstIndex(of: ",") else {
			return nil
		}
		let match = description[startIndex..<endIndex]
		return Int(match)
	}

}
