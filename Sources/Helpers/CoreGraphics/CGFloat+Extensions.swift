// CGFloat+Extensions.swift, 19.11.2022.
// Copyright © 2022 Stanislav Lomachinskiy.

import Foundation

public extension CGFloat {

	/// Creates an instance initialized with a string.
	init?(_ string: String) {
		guard let value = NativeType(string) else {
			return nil
		}
		self.init(value)
	}

}
