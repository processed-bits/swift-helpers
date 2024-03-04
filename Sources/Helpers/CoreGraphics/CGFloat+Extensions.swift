// CGFloat+Extensions.swift, 19.11.2022-23.03.2024.
// Copyright © 2022-2024 Stanislav Lomachinskiy.

import CoreFoundation

public extension CGFloat {

	/// Creates an instance initialized with a string.
	init?(_ string: String) {
		guard let value = NativeType(string) else {
			return nil
		}
		self.init(value)
	}

}
