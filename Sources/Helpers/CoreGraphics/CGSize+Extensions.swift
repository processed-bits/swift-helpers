// CGSize+Extensions.swift, 22.07.2021-06.03.2023.
// Copyright © 2021-2023 Stanislav Lomachinskiy.

import Foundation

public extension CGSize {

	// MARK: Initializers

	/// Creates a size from a string representation.
	///
	/// - Parameters:
	///   - string: A string containing `width` and `height` values for the size to create.
	///   - separator: A separator character used to split `width` and `height` values. The default is `x`.
	init?(string: String, separator: String.Element = "x") {
		let stringComponents = string.split(separator: separator, maxSplits: 1, omittingEmptySubsequences: false).map { $0.trimmed }
		let sizeStrings = stringComponents.compactMap { CGFloat($0) }
		guard sizeStrings.count == 2,
		      let width = sizeStrings.first,
		      let height = sizeStrings.last else {
			return nil
		}
		self.init(width: width, height: height)
	}

	// MARK: Geometric Properties

	/// The aspect ratio (width divided by height) of the size.
	var aspectRatio: CGFloat {
		width / height
	}

}
