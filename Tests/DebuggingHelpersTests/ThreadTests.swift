// ThreadTests.swift, 06.04.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

import DebuggingHelpers
import Foundation
import StandardLibraryHelpers
import Testing

struct ThreadTests {

	@Test func properties() throws {
		let thread = Thread.current
		let memoryAddress = thread.memoryAddress
		let number = thread.number

		let pairs: KeyValuePairs<String, Any> = [
			"Thread": thread,
			"Thread number": number as Any,
			"Thread memory address": memoryAddress as Any,
		]
		print(pairs.formatted(keySuffix: ":"))

		#if os(Linux)
			#expect(number == nil)
		#else
			#expect(number != nil)
		#endif
		#expect(memoryAddress != nil)
	}

}
