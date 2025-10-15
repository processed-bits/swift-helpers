// BufferedOutput.swift, 28.03.2023.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

import Foundation
import SynchronizationHelpers

/// A buffered output object.
public class BufferedOutput: @unchecked Sendable, TextOutputStreamable {

	/// The chunks are basic elements of the buffered output.
	@AtomicSerial private var chunks: [Chunk] = []

	/// The buffered output stream for standard output.
	public lazy var output = Stream(bufferedOutput: self, kind: .standardOutput)
	/// The buffered output stream for standard error.
	public lazy var error = Stream(bufferedOutput: self, kind: .standardError)

	// MARK: Creating a Buffered Output Object

	/// Creates a buffered output instance.
	public init() {}

	// MARK: Appending to Buffered Output

	/// Adds a new string to the end of the corresponding stream.
	public func append(string: String, to streamKind: OutputStreamKind) {
		_chunks.withLock { chunks in
			let chunk = Chunk(streamKind: streamKind, string: string)
			chunks.append(chunk)
		}
	}

	/// Adds the contents of another buffered output object to the end of this object.
	public func append(contentsOf other: BufferedOutput) {
		assert(self !== other, "Can’t append buffered output to self.")
		_chunks.withLock { chunks in
			chunks.append(contentsOf: other.chunks)
		}
	}

	// MARK: Printing Buffered Output

	/// Writes the buffered output to the respective streams.
	public func print() {
		_chunks.withLock { chunks in
			for chunk in chunks {
				chunk.print()
			}
		}
	}

	/// Writes the buffered output into the given output stream.
	public func write(to target: inout some TextOutputStream) {
		_chunks.withLock { chunks in
			for chunk in chunks {
				chunk.write(to: &target)
			}
		}
	}

	// MARK: Chunk

	/// A structure that stores a block of output.
	private struct Chunk: Sendable, TextOutputStreamable {
		let streamKind: OutputStreamKind
		let string: String

		/// Writes the chunk to the respective stream.
		func print() {
			OutputHelpers.print(string, terminator: "", to: streamKind)
		}

		/// Writes the chunk into the given output stream.
		func write(to target: inout some TextOutputStream) {
			target.write(string)
		}
	}

	// MARK: Stream

	/// A buffered output stream that may be used both as a target and as a source of text-streaming operations.
	public class Stream: TextOutputStream, TextOutputStreamable {
		/// The buffered output that contains this stream.
		unowned let bufferedOutput: BufferedOutput
		/// The buffered output stream kind.
		let streamKind: OutputStreamKind

		/// Creates a buffered output stream.
		public init(bufferedOutput: BufferedOutput, kind: OutputStreamKind) {
			self.bufferedOutput = bufferedOutput
			streamKind = kind
		}

		/// Writes the string to the buffered output.
		public func write(_ string: String) {
			bufferedOutput._chunks.withLock { chunks in
				let chunk = Chunk(streamKind: streamKind, string: string)
				chunks.append(chunk)
			}
		}

		/// Writes the buffered output of this stream kind into the given output stream.
		public func write(to target: inout some TextOutputStream) {
			bufferedOutput.chunks.lazy
				.filter { $0.streamKind == self.streamKind }
				.forEach { target.write($0.string) }
		}

		/// The string representation of the stream.
		public var string: String {
			var output = ""
			Swift.print(self, terminator: "", to: &output)
			return output.trimmingCharacters(in: .newlines)
		}
	}

}

// MARK: - Deprecated

public extension BufferedOutput {

	@available(*, deprecated, renamed: "print()")
	func flush() {
		print()
	}

}
