// NSTextCheckingResult+Extensions.swift, 12.12.2017-05.04.2024.
// Copyright © 2017-2024 Stanislav Lomachinskiy.

import Foundation

/// Range, capture group, line number.
public extension NSTextCheckingResult {

	// MARK: Range

	/// Returns the range of the result with the specified index.
	func range(at index: Int = 0, in string: String) -> Range<String.Index>? {
		Range(range(at: index), in: string)
	}

	/// Returns the range of the result with the specified name.
	@available(iOS 11.0, macOS 10.13, macCatalyst 13.1, tvOS 11.0, watchOS 4.0, *)
	func range(withName name: String, in string: String) -> Range<String.Index>? {
		Range(range(withName: name), in: string)
	}

	// MARK: Capture Group

	/// Returns the capture group with the specified index.
	func captureGroup(at index: Int = 0, in string: String) -> String? {
		guard let range = range(at: index, in: string) else {
			return nil
		}
		return String(string[range])
	}

	/// Returns the capture group with the specified name.
	@available(iOS 11.0, macOS 10.13, macCatalyst 13.1, tvOS 11.0, watchOS 4.0, *)
	func captureGroup(withName name: String, in string: String) -> String? {
		guard let range = range(withName: name, in: string) else {
			return nil
		}
		return String(string[range])
	}

	// MARK: Line Number

	/// Returns the line number of the result with the specified index.
	func lineNumber(at index: Int = 0, in string: String) -> Int? {
		guard let range = range(at: index, in: string) else {
			return nil
		}
		return lineNumber(range: range, in: string)
	}

	/// Returns the line number of the result with the specified name.
	@available(iOS 11.0, macOS 10.13, macCatalyst 13.1, tvOS 11.0, watchOS 4.0, *)
	func lineNumber(withName name: String, in string: String) -> Int? {
		guard let range = range(withName: name, in: string) else {
			return nil
		}
		return lineNumber(range: range, in: string)
	}

	/// Returns the line number where the specified range starts.
	private func lineNumber(range: Range<String.Index>, in string: String) -> Int {
		let fullRange = string.startIndex ... range.lowerBound
		let lineNumber = string[fullRange].reduce(1) { result, character in
			character == "\n" ? result + 1 : result
		}
		return lineNumber
	}

}
