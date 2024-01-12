// ProcessOutputTests.swift, 13.04.2023-15.04.2023.
// Copyright © 2023 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class ProcessOutputTests: XCTestCase {

	private let outputString = "Test output."
	private let errorString = "Test error."
	private lazy var script =
		"""
		echo \(outputString)
		echo \(errorString) >&2
		"""

	func testDetachedOutput() async throws {
		// Set up process and output.
		let process = Process(script: script)
		XCTAssertTrue(process.isUsingStandardOutput)
		XCTAssertTrue(process.isUsingStandardError)
		process.detachOutput()
		XCTAssertFalse(process.isUsingStandardOutput)
		XCTAssertFalse(process.isUsingStandardError)
		XCTAssertNotEqual(process.standardOutput as? Pipe, process.standardError as? Pipe)
		// Run and check output.
		try await process.runUntilExit()
		let output = try XCTUnwrap(process.flatOutput())
		let error = try XCTUnwrap(process.flatOutput(streamKind: .standardError))
		XCTAssertEqual(output, outputString)
		XCTAssertEqual(error, errorString)
	}

	func testDetachedCombinedOutput() async throws {
		// Set up process and output.
		let process = Process(script: script)
		XCTAssertTrue(process.isUsingStandardOutput)
		XCTAssertTrue(process.isUsingStandardError)
		process.detachCombinedOutput()
		XCTAssertFalse(process.isUsingStandardOutput)
		XCTAssertFalse(process.isUsingStandardError)
		XCTAssertEqual(process.standardOutput as? Pipe, process.standardError as? Pipe)
		// Run and check output.
		try await process.runUntilExit()
		let output = try XCTUnwrap(process.flatOutput())
		XCTAssertEqual(output, [outputString, errorString].joined(separator: "\n"))
	}

	@available(macOS 12.0, *)
	func testBufferedOutput() async throws {
		// Set up process and output.
		let process = Process(script: script)
		XCTAssertTrue(process.isUsingStandardOutput)
		XCTAssertTrue(process.isUsingStandardError)
		// Run and check output.
		let bufferedOutput = try await process.runUntilEndOfOutput()
		XCTAssertFalse(process.isUsingStandardOutput)
		XCTAssertFalse(process.isUsingStandardError)
		XCTAssertNotEqual(process.standardOutput as? Pipe, process.standardError as? Pipe)
		XCTAssertEqual(bufferedOutput.output.string, outputString)
		XCTAssertEqual(bufferedOutput.error.string, errorString)
	}

}
