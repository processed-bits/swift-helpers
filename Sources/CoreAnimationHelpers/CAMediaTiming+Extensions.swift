// CAMediaTiming+Extensions.swift, 26.11.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

#if canImport(QuartzCore)
	import QuartzCore

	public extension CAMediaTiming {

		/// Current absolute time, in seconds.
		///
		/// See also  [`CACurrentMediaTime()`](https://developer.apple.com/documentation/quartzcore/1395996-cacurrentmediatime).
		var currentMediaTime: CFTimeInterval {
			CACurrentMediaTime()
		}

	}
#endif
