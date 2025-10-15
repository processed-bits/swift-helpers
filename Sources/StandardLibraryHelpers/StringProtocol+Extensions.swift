// StringProtocol+Extensions.swift, 19.08.2022.
// Copyright © 2022-2024 Stanislav Lomachinskiy.

import Foundation

public extension StringProtocol {

	// MARK: Trimming

	/// A new string made by removing from both ends of the receiver whitespace and newline characters.
	var trimmed: String {
		trimmingCharacters(in: .whitespacesAndNewlines)
	}

}
