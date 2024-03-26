// Unicode.Scalar+Extensions.swift, 22.11.2022-07.03.2024.
// Copyright © 2022-2024 Stanislav Lomachinskiy.

/// Additional initializer.
public extension Unicode.Scalar {

	/// Creates a Unicode scalar with the specified character.
	init?(_ character: Character) {
		self.init(String(character))
	}

}
