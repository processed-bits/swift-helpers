// BufferedOutputCollector.swift, 02.04.2023.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

import Foundation

// swiftlint:disable deployment_target

/// An object that collects buffered output using pipes.
@available(iOS 8.0, macOS 10.10, macCatalyst 13.0, tvOS 9.0, watchOS 2.0, *)
public final class BufferedOutputCollector: Sendable {

	private let bufferedOutput: BufferedOutput

	/// The standard output pipe.
	public let outputPipe: Pipe
	/// The standard error pipe.
	public let errorPipe: Pipe

	private let encoding: String.Encoding
	private let pipesGroup = DispatchGroup()

	/// Creates a collector.
	///
	/// - Parameters:
	///   - bufferedOutput: A buffered output object. You may provide an existing object. The default is a new object.
	///   - outputPipe: A pipe used for reading standard output. The default is a new pipe.
	///   - errorPipe: A pipe used for reading standard error. The default is a new pipe.
	///   - encoding: The string encoding. The default is UTF-8.
	///
	/// You may create new buffered output object and pipes or reuse existing ones.
	public init(
		bufferedOutput: BufferedOutput = .init(),
		outputPipe: Pipe = .init(),
		errorPipe: Pipe = .init(),
		encoding: String.Encoding = .utf8
	) {
		self.bufferedOutput = bufferedOutput
		self.outputPipe = outputPipe
		self.errorPipe = errorPipe
		self.encoding = encoding

		read(from: outputPipe, streamKind: .standardOutput)
		read(from: errorPipe, streamKind: .standardError)
	}

	private func read(from pipe: Pipe, streamKind: OutputStreamKind) {
		// Enter the group.
		pipesGroup.enter()
		pipe.fileHandleForReading.readabilityHandler = { [self] fileHandle in
			let data = fileHandle.availableData

			// Empty data signals EOF.
			guard !data.isEmpty, let string = String(data: data, encoding: encoding) else {
				// Stop reading the pipe, leave the dispatch group.
				fileHandle.readabilityHandler = nil
				pipesGroup.leave()
				return
			}

			bufferedOutput.append(string: string, to: streamKind)
		}
	}

	/// Waits until the end of piped output and returns the buffered output object.
	@discardableResult public func waitUntilEndOfOutput() -> BufferedOutput {
		pipesGroup.wait()
		return bufferedOutput
	}

}

// swiftlint:enable deployment_target
