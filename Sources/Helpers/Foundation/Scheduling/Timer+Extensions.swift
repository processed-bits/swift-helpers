// Timer+Extensions.swift, 25.08.2020-03.04.2024.
// Copyright © 2020-2024 Stanislav Lomachinskiy. All rights reserved.

import Foundation

public extension Timer {

	/// Creates a timer and schedules it on the current run loop in the given input mode.
	///
	/// After `interval` seconds have elapsed, the timer fires, executing `block`.
	///
	/// - Parameters:
	///   - interval: The number of seconds between firings of the timer. If `interval` is less than or equal to `0.0`, this method chooses the nonnegative value of `0.0001` seconds instead.
	///   - repeats: If `true`, the timer will repeatedly reschedule itself until invalidated. If `false`, the timer will be invalidated after it fires.
	///   - mode: The mode in which to add the timer. You may specify a custom mode or use one of the modes listed in [Run Loop Modes](https://developer.apple.com/documentation/foundation/runloop/mode).
	///   - block: A block to be executed when the timer fires. The block takes a single `Timer` parameter and has no return value.
	/// - Returns: A new `Timer` object, configured according to the specified parameters.
	@discardableResult class func scheduledTimer(
		withTimeInterval interval: TimeInterval,
		repeats: Bool,
		forMode mode: RunLoop.Mode,
		block: @escaping @Sendable (Timer) -> Void
	) -> Timer {
		let timer = Timer(timeInterval: interval, repeats: repeats, block: block)
		RunLoop.current.add(timer, forMode: mode)
		return timer
	}

}
