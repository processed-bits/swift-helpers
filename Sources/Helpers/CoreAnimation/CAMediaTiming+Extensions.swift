// CAMediaTiming+Extensions.swift, 26.11.2022.
// Copyright © 2022 Stanislav Lomachinskiy.

import Cocoa

public extension CAMediaTiming {

	/// Current absolute time, in seconds.
	///
	/// See also  [`CACurrentMediaTime()`](https://developer.apple.com/documentation/quartzcore/1395996-cacurrentmediatime).
	var currentMediaTime: CFTimeInterval {
		CACurrentMediaTime()
	}

}
