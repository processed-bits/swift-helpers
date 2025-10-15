// BufferedOutputTests.swift, 13.04.2023.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

import OutputHelpers
import Testing

struct BufferedOutputTests {

	@Test func bufferingAndPrinting() throws {
		let bufferedOutput = BufferedOutput()
		print("This is buffered output from line \(#line).", to: &bufferedOutput.output)
		print("This is unbuffered output from line \(#line).")
		print(bufferedOutput.output, terminator: "")
	}

}
