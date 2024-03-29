// NSObject+Bindings.swift, 03.12.2022-06.03.2024.
// Copyright © 2022-2024 Stanislav Lomachinskiy.

#if os(macOS)
	import Foundation

	/// `NSKeyValueBindingCreation` informal protocol extension.
	public extension NSObject {

		/// Removes the bindings exposed by the receiver.
		func unbindExposedBindings() {
			for binding in exposedBindings {
				unbind(binding)
			}
		}

	}
#endif
