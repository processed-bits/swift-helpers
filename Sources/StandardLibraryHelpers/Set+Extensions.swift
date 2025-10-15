// Set+Extensions.swift, 28.01.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import Foundation

/// Additional initializer.
public extension Set {

	/// Creates a new set from a string.
	///
	/// - Parameters:
	///   - string: The string to split.
	///   - separator: The element that should be split upon.
	///   - maxSplits: The maximum number of times to split the collection, or one less than the number of subsequences to return. If `maxSplits + 1` subsequences are returned, the last one is a suffix of the original collection containing the remaining elements. `maxSplits` must be greater than or equal to zero. The default value is `Int.max`.
	///   - omittingEmptySubsequences: If `false`, an empty subsequence is returned in the result for each consecutive pair of `separator` elements in the collection and for each instance of `separator` at the start or end of the collection. If `true`, only nonempty subsequences are returned. The default value is `true`.
	///   - trimCharacters: Character set  to use for removing characters from both ends of the `String`. The default value is `.whitespaces`.
	init(from string: String, separator: Character, maxSplits: Int = .max, omittingEmptySubsequences: Bool = true, trimCharacters: CharacterSet? = .whitespaces) where Element == String {
		let substrings = string.split(separator: separator, maxSplits: maxSplits, omittingEmptySubsequences: omittingEmptySubsequences)
		let strings: [String] = if let trimCharacters {
			substrings.map { $0.trimmingCharacters(in: trimCharacters) }
		} else {
			substrings.map { String($0) }
		}
		self.init(strings)
	}

}
