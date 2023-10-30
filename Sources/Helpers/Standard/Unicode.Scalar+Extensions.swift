// Unicode.Scalar+Extensions.swift, 22.11.2022-23.11.2022.
// Copyright © 2022 Stanislav Lomachinskiy.

import Foundation

/// Additional initializer.
public extension Unicode.Scalar {

	/// Creates a Unicode scalar with the specified character.
	init?(_ character: Character) {
		self.init(String(character))
	}

}
