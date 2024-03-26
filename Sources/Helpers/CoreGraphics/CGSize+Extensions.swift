// CGSize+Extensions.swift, 22.07.2021-23.03.2024.
// Copyright © 2021-2024 Stanislav Lomachinskiy.

import CoreFoundation

public extension CGSize {

	// MARK: Initializers

	/// Creates a size from a string representation.
	///
	/// - Parameters:
	///   - string: A string containing `width` and `height` values for the size to create.
	///   - separator: A separator character used to split `width` and `height` values. The default is `x`.
	init?(string: String, separator: String.Element = "x") {
		let stringComponents = string.split(separator: separator, maxSplits: 1, omittingEmptySubsequences: false).map { $0.trimmed }
		let sizeStrings = stringComponents.compactMap { CGFloat.NativeType($0) }
		guard sizeStrings.count == 2,
		      let width = sizeStrings.first,
		      let height = sizeStrings.last else {
			return nil
		}
		if #available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, visionOS 1.0, watchOS 9.0, *) {
			self.init(width: width, height: height)
		} else {
			self.init()
			self.width = width
			self.height = height
		}
	}

	// MARK: Geometric Properties

	#if arch(x86_64) || arch(arm64)
		/// The aspect ratio (width divided by height) of the size.
		@available(iOS 2.0, macOS 10.0, macCatalyst 13.0, tvOS 9.0, visionOS 1.0, *)
		// swiftlint:disable:previous deployment_target
		var aspectRatio: Double {
			width / height
		}
	#else
		/// The aspect ratio (width divided by height) of the size.
		@available(watchOS 2.0, *)
		var aspectRatio: Float {
			width / height
		}
	#endif

}
