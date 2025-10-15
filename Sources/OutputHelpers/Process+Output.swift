// Process+Output.swift, 27.05.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

#if os(macOS) || targetEnvironment(macCatalyst)
	import Foundation

	@available(macOS 10.15.4, macCatalyst 15.0, *)
	public extension Process {

		// MARK: Configuring a Process Object

		/// A Boolean that is true if the process is using standard output.
		var isUsingStandardOutput: Bool { standardOutput as? FileHandle == FileHandle.standardOutput }
		/// A Boolean that is true if the process is using standard error.
		var isUsingStandardError: Bool { standardError as? FileHandle == FileHandle.standardError }

		/// Detaches standard output and error, and redirects it to respective pipes.
		func detachOutput(outputPipe: Pipe = .init(), errorPipe: Pipe = .init()) {
			standardOutput = outputPipe
			standardError = errorPipe
		}

		/// Detaches standard output and error, and redirects it to a single pipe.
		func detachCombinedOutput(pipe: Pipe = .init()) {
			detachOutput(outputPipe: pipe, errorPipe: pipe)
		}

		// MARK: Getting Flattened Output of a Process

		/// Returns flattened output as a string.
		///
		/// - Parameters:
		///   - streamKind: The output stream kind. The default is standard output.
		///   - encoding: The string encoding. The default is UTF-8.
		///
		/// Use flattened output when you only need either of the streams (output or error), or you need combined output without distinguishing its streams.
		///
		/// You must detach standard output and error before running the process.
		func flatOutput(
			streamKind: OutputStreamKind = .standardOutput,
			encoding: String.Encoding = .utf8
		) -> String? {
			switch streamKind {
			case .standardOutput:
				precondition(!isUsingStandardOutput, "Can’t read flattened output. The process is using standard output.")
				return flatOutput(for: standardOutput, encoding: encoding)
			case .standardError:
				precondition(!isUsingStandardError, "Can’t read flattened output. The process is using standard error.")
				return flatOutput(for: standardError, encoding: encoding)
			}
		}

		// MARK: Private Helpers

		private func flatOutput(
			for pipeOrFileHandle: Any?,
			encoding: String.Encoding = .utf8
		) -> String? {
			switch pipeOrFileHandle {
			case let pipe as Pipe:
				let fileHandle = pipe.fileHandleForReading
				return flatOutput(forHandle: fileHandle, encoding: encoding)
			case let fileHandle as FileHandle:
				return flatOutput(forHandle: fileHandle, encoding: encoding)
			default:
				return nil
			}
		}

		private func flatOutput(
			forHandle fileHandle: FileHandle,
			encoding: String.Encoding = .utf8
		) -> String? {
			guard let data = try? fileHandle.readToEnd() else {
				return nil
			}

			let output = String(data: data, encoding: encoding)?.trimmingCharacters(in: .newlines)
			return output
		}

		// MARK: Running a Process with Output Buffering

		/// Runs the process and returns the buffered output object.
		///
		/// - Note: A `Process` instance method `waitUntilExit()` returns some milliseconds later than this method (though `isRunning` will already return `false` after this method).
		func runUntilEndOfOutput() async throws -> BufferedOutput {
			try await runUntilEndOfOutput(using: .init())
		}

		/// Runs the process and returns the buffered output object.
		///
		/// - Note: A `Process` instance method `waitUntilExit()` returns some milliseconds later than this method (though `isRunning` will already return `false` after this method).
		@discardableResult func runUntilEndOfOutput(using bufferedOutput: BufferedOutput) async throws -> BufferedOutput {
			let collector = BufferedOutputCollector(bufferedOutput: bufferedOutput)
			detachOutput(outputPipe: collector.outputPipe, errorPipe: collector.errorPipe)
			try run()
			return collector.waitUntilEndOfOutput()
		}

	}
#endif
