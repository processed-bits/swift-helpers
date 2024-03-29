// NSImage+Extensions.swift, 12.09.2019-06.03.2024.
// Copyright © 2019-2024 Stanislav Lomachinskiy.

#if os(macOS)
	import AppKit

	public extension NSImage {

		/// Removes and releases the image representations that satisfy the given predicate.
		///
		/// - Parameters:
		///   - predicate: A closure that takes an image representation as its argument and returns a Boolean value indicating whether the representation should be removed.
		func removeRepresentations(where predicate: (NSImageRep) throws -> Bool) rethrows {
			let representationsToRemove = try representations.filter(predicate)
			representationsToRemove.forEach { removeRepresentation($0) }
		}

	}
#endif
