// CGSizeTests.swift, 19.11.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

#if canImport(CoreFoundation) && !os(Linux)
	import CoreFoundation
	import CoreGraphicsHelpers
	import Testing

	struct CGSizeTests {

		@Test func sizeFromString() throws {
			let initialSize = CGSize(width: 123, height: 456)
			let correctStrings = [
				"\(initialSize.width)x\(initialSize.height)",
				"\(initialSize.width) x \(initialSize.height)",
				"\(initialSize.width) x  \(initialSize.height)",
				"\(initialSize.width)  x \(initialSize.height)",
				"\(initialSize.width)  x  \(initialSize.height)",
			]
			let incorrectStrings = [
				"\(initialSize.width)",
				"\(initialSize.width)x",
				"\(initialSize.width)x\(initialSize.height)x\(initialSize.width)",
				"x\(initialSize.width)x\(initialSize.height)",
				"\(initialSize.width)x\(initialSize.height)x",
			]
			for string in correctStrings {
				let size = try #require(CGSize(string: string))
				#expect(initialSize.width == size.width && initialSize.height == size.height)
			}
			for string in incorrectStrings {
				let size = CGSize(string: string)
				#expect(initialSize.width != size?.width || initialSize.height != size?.height)
			}
		}

	}
#endif
