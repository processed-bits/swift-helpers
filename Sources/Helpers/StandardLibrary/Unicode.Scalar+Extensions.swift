// Unicode.Scalar+Extensions.swift, 22.11.2022-03.01.2025.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

/// Additional initializer.
public extension Unicode.Scalar {

	// MARK: Creating a Scalar

	/// Creates a Unicode scalar with the specified character.
	init?(_ character: Character) {
		self.init(String(character))
	}

}
