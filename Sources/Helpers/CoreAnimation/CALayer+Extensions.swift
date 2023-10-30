// CALayer+Extensions.swift, 30.04.2019-03.12.2022.
// Copyright © 2019-2022 Stanislav Lomachinskiy.

import Cocoa

public extension CALayer {

	// MARK: Animations

	/// Add an animated cross fade transition of the opacity to the layer’s render tree.
	///
	/// The value of the `newOpacity` parameter must not equal the value of the `opacity` property and must be in the range `0.0` (transparent) to `1.0` (opaque). Values outside that range are clamped to the minimum or maximum. The default value of this property is `1.0`.
	///
	/// If the `duration` parameter is zero or negative, the duration is changed to the current value of the [`kCATransactionAnimationDuration`](https://developer.apple.com/documentation/quartzcore/kcatransactionanimationduration) transaction property (if set) or to the default value of `0.25` seconds.
	///
	/// - Parameters:
	///   - newOpacity: The new opacity of the receiver.
	///   - duration: Specifies the basic duration of the animation, in seconds. Defaults to `0`.
	func fade(to newOpacity: Float, duration: CFTimeInterval = 0) {
		guard opacity != newOpacity else {
			return
		}
		let transition = CATransition()
		if duration > 0 {
			transition.duration = duration
		}
		add(transition, forKey: nil)
		opacity = newOpacity
	}

	// MARK: Actions

	/// Update layer actions merging new actions into existing actions using their keys. New actions will replace existing ones.
	///
	/// If `newActions` dictionary is empty, this method does nothing.
	///
	/// - Parameters:
	///   - newActions: A dictionary containing layer actions.
	func updateActions(with newActions: [String: CAAction]) {
		guard !newActions.isEmpty else {
			return
		}
		if let actions {
			self.actions = actions.merging(newActions) { _, new in new }
		} else {
			actions = newActions
		}
	}

}
