// KeyValuePairs+Extensions.swift, 19.11.2023.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

public extension KeyValuePairs {

	// MARK: Formatting Key-Value Pairs

	/// Creates a string representation of key-value pairs where values are aligned for monospaced output.
	///
	/// - Parameters:
	///   - maxKeyLength: The maximum key length, must be greater than zero. Defaults to `nil`, which will use the length of the longest key.
	///   - keyTruncationTerminator: The key truncation termination string. Defaults to ``String/defaultTruncationTerminator``.
	///   - keySuffix: A string to add after each truncated key. Defaults to an empty string.
	///   - keyValueSeparator: A string to use as a key-value separator. Defaults to a space.
	///
	/// Each output line may be expressed by the pseudocode:
	///
	/// ```
	/// truncatedKey + keySuffix + padding + keyValueSeparator + value
	/// ```
	///
	/// You may obtain different output styles by customizing the key suffix or the key-value separator. For example, use a colon (`:`) as a key suffix for a minimalistic, but delimited style. Or use an arrow surrounded by spaces (` → `) as a key-value separator for an expressive delimited style.
	func formatted(
		maxKeyLength: Int? = nil,
		keyTruncationTerminator: any StringProtocol = String.defaultTruncationTerminator,
		keySuffix: String = "",
		keyValueSeparator: String = " "
	) -> String where Key == String {
		lazy var longestKeyLength = map(\.key.count).max()

		// The collection must not be empty (then `keyLength` will always be unwrapped). Otherwise, return an empty string.
		guard !isEmpty, let keyLength = maxKeyLength ?? longestKeyLength else {
			return ""
		}

		guard keyLength > 0 else {
			fatalError("`keyLength` must be greater than zero.")
		}

		var lines: [String] = []
		for (key, value) in self {
			let truncatedKey = key.truncated(to: keyLength, with: keyTruncationTerminator) + keySuffix
			// Pad the key to the length including the key suffix.
			let paddedKey = truncatedKey.padding(toLength: keyLength + keySuffix.count)
			let line = paddedKey + keyValueSeparator + String(describing: value)
			lines.append(line)
		}
		return lines.joined(separator: "\n")
	}

	@available(*, deprecated, message: "Please use formatted(maxKeyLength:keyTruncationTerminator:keySuffix:keyValueSeparator:).")
	func format(keyColumnWidth: Int? = nil, keyTerminator: String = "") -> String where Key == String {
		formatted(maxKeyLength: keyColumnWidth, keySuffix: keyTerminator)
	}

}
