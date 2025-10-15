// ProcessOutputTests.swift, 13.04.2023.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

#if os(macOS)
	import Foundation
	import FoundationHelpers
	import OutputHelpers
	import Testing

	struct ProcessOutputTests {

		private let outputString = "Test output."
		private let errorString = "Test error."
		private lazy var script =
			"""
			echo \(outputString)
			echo \(errorString) >&2
			"""

		@Test mutating func detachedOutput() async throws {
			// Set up process and output.
			let process = Process(script: script)
			#expect(process.isUsingStandardOutput)
			#expect(process.isUsingStandardError)

			process.detachOutput()
			#expect(!process.isUsingStandardOutput)
			#expect(!process.isUsingStandardError)
			#expect(process.standardOutput as? Pipe != process.standardError as? Pipe)

			// Run and check output.
			try await process.runUntilExit()
			let output = try #require(process.flatOutput())
			let error = try #require(process.flatOutput(streamKind: .standardError))
			#expect(output == outputString)
			#expect(error == errorString)
		}

		@Test mutating func detachedCombinedOutput() async throws {
			// Set up process and output.
			let process = Process(script: script)
			#expect(process.isUsingStandardOutput)
			#expect(process.isUsingStandardError)

			process.detachCombinedOutput()
			#expect(!process.isUsingStandardOutput)
			#expect(!process.isUsingStandardError)
			#expect(process.standardOutput as? Pipe == process.standardError as? Pipe)

			// Run and check output.
			try await process.runUntilExit()
			let output = try #require(process.flatOutput())
			#expect(output == [outputString, errorString].joined(separator: "\n"))
		}

		@available(macOS 12.0, *)
		@Test mutating func bufferedOutput() async throws {
			// Set up process and output.
			let process = Process(script: script)
			#expect(process.isUsingStandardOutput)
			#expect(process.isUsingStandardError)

			// Run and check output.
			let bufferedOutput = try await process.runUntilEndOfOutput()
			#expect(!process.isUsingStandardOutput)
			#expect(!process.isUsingStandardError)
			#expect(process.standardOutput as? Pipe != process.standardError as? Pipe)
			#expect(bufferedOutput.output.string == outputString)
			#expect(bufferedOutput.error.string == errorString)
		}

	}
#endif
