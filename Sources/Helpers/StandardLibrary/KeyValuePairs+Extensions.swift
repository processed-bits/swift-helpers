// KeyValuePairs+Extensions.swift, 19.11.2023-07.03.2024.
// Copyright © 2023-2024 Stanislav Lomachinskiy.

/// Formatting helpers.
public extension KeyValuePairs {

	/// Creates a string representation of key-value pairs where values are aligned for monospaced output.
	///
	/// - Parameters:
	///   - keyColumnWidth: The width of the key column. The default is `nil`, which will use the width of the longest key.
	///   - keyTerminator: A string to add after each key. The default terminator is an empty string.
	///
	/// Keys and values are separated by at least one space. When key terminator is used, the width of the key column will be adjusted. This method is intended for debug logging during development.
	func format(keyColumnWidth: Int? = nil, keyTerminator: String = "") -> String where Key == String {
		var lines: [String] = []
		let keyColumnWidth = (keyColumnWidth ?? map { $0.key }.max()?.count ?? 0)
		for (key, value) in self {
			let keyColumn = key.truncated(to: keyColumnWidth) + keyTerminator
			let line = keyColumn.padding(toLength: keyColumnWidth + keyTerminator.count) + " " + String(describing: value)
			lines.append(line)
		}
		return lines.joined(separator: "\n")
	}

}
