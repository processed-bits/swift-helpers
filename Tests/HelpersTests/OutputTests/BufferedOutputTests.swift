// BufferedOutputTests.swift, 13.04.2023.
// Copyright © 2023 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class BufferedOutputTests: XCTestCase {

	func testBufferingAndPrinting() throws {
		let bufferedOutput = BufferedOutput()
		print("This is buffered output from line \(#line).", to: &bufferedOutput.output)
		print("This is unbuffered output from line \(#line).")
		print(bufferedOutput.output, terminator: "")
	}

}
