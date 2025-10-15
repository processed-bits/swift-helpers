// CharacterSet+Extensions.swift, 26.12.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation

public extension CharacterSet {

	// MARK: Inspecting a Character Set

	/// Unicode scalar values that are contained in the character set.
	///
	/// This property is intended only for inspection and testing, and may be computationally expensive for large character sets.
	///
	/// To create an array of characters, use mapping:
	///
	///	```swift
	/// let characters = scalars.map(Character.init)
	/// ```
	var scalars: [Unicode.Scalar] {
		bitmapRepresentation.nonzeroBits.compactMap(Unicode.Scalar.init)
	}

}
