// Collection+Extensions.swift, 18.05.2022-05.05.2023.
// Copyright © 2022-2023 Stanislav Lomachinskiy.

import Foundation

public extension Collection {

	// MARK: Transforming a Collection

	/// Returns the collection elements or `nil` if the collection is empty.
	var nilIfEmpty: Self? {
		isEmpty ? nil : self
	}

}

public extension Collection<String?> {

	// MARK: Joining Optional Strings

	/// Returns a new string by concatenating the non-`nil` elements of the sequence, adding the given separator between each element.
	///
	/// - Parameters:
	///   - separator: A string to insert between each of the elements in this sequence. The default separator is an empty string.
	/// - Returns: A single, concatenated string or `nil` if all elements are `nil`.
	func joined(separator: String = "") -> String? {
		compacted().nilIfEmpty?.joined(separator: separator)
	}

}
