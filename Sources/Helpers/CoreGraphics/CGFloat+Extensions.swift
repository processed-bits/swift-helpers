// CGFloat+Extensions.swift, 19.11.2022-14.02.2025.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

#if canImport(CoreFoundation)
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
#endif
