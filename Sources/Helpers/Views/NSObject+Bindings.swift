// NSObject+Bindings.swift, 03.12.2022.
// Copyright © 2022 Stanislav Lomachinskiy.

import Foundation

// `NSKeyValueBindingCreation` informal protocol.
public extension NSObject {

	/// Removes the bindings exposed by the receiver.
	func unbindExposedBindings() {
		for binding in exposedBindings {
			unbind(binding)
		}
	}

}
