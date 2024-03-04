// BufferedOutput.swift, 28.03.2023-23.03.2024.
// Copyright © 2023-2024 Stanislav Lomachinskiy.

/// A buffered output object.
public class BufferedOutput: TextOutputStreamable {

	/// The chunks are basic elements of the buffered output.
	@Atomic private var chunks: [Chunk] = []

	/// The buffered output stream for standard output.
	public lazy var output = OutputStream(bufferedOutput: self, kind: .standardOutput)
	/// The buffered output stream for standard error.
	public lazy var error = OutputStream(bufferedOutput: self, kind: .standardError)

	// MARK: Creating a Buffered Output Object

	/// Creates a buffered output instance.
	public init() {}

	// MARK: Appending to Buffered Output

	/// Adds a new string to the end of the corresponding stream.
	public func append(string: String, to streamKind: OutputStreamKind) {
		_chunks.mutatingBlock { chunks in
			let chunk = Chunk(streamKind: streamKind, string: string)
			chunks.append(chunk)
		}
	}

	/// Adds the contents of another buffered output object to the end of this object.
	public func append(contentsOf other: BufferedOutput) {
		assert(self !== other, "Can't append buffered output to self.")
		_chunks.mutatingBlock { chunks in
			chunks.append(contentsOf: other.chunks)
		}
	}

	// MARK: Printing Buffered Output

	/// Writes the buffered output to the respective streams.
	public func flush() {
		for chunk in chunks {
			chunk.print()
		}
	}

	/// Writes the buffered output into the given output stream.
	public func write<Target: TextOutputStream>(to target: inout Target) {
		for chunk in chunks {
			chunk.write(to: &target)
		}
	}

	// MARK: - Supporting Types

	/// A structure that stores a block of output.
	private struct Chunk: TextOutputStreamable {

		let streamKind: OutputStreamKind
		let string: String

		/// Writes the chunk to the respective stream.
		func print() {
			Helpers.print(string, terminator: "", to: streamKind)
		}

		/// Writes the chunk into the given output stream.
		func write<Target: TextOutputStream>(to target: inout Target) {
			target.write(string)
		}

	}

	/// A buffered output stream that may be used both as target and source of text-streaming operations.
	public class OutputStream: TextOutputStream, TextOutputStreamable {

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
			bufferedOutput._chunks.mutatingBlock { chunks in
				let chunk = Chunk(streamKind: streamKind, string: string)
				chunks.append(chunk)
			}
		}

		/// Writes the buffered output of this stream kind into the given output stream.
		public func write<Target: TextOutputStream>(to target: inout Target) {
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
