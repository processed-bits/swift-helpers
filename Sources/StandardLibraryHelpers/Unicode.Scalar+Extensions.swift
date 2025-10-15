// Unicode.Scalar+Extensions.swift, 22.11.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

public extension Unicode.Scalar {

	// MARK: Creating a Scalar

	/// Creates a Unicode scalar with the specified character.
	init?(_ character: Character) {
		self.init(String(character))
	}

}
