// dumpOutput.swift, 25.02.2023-23.03.2024.
// Copyright © 2023-2024 Stanislav Lomachinskiy.

/// Returns a dump of the given object’s contents.
///
/// - Parameters:
///   - value: The value to output.
///   - name: A label to use when writing the contents of `value`. When `nil` is passed, the label is omitted. The default is `nil`.
///   - indent: The number of spaces to use as an indent for each line of the output. The default is `0`.
///   - maxDepth: The maximum depth to descend when writing the contents of a value that has nested components. The default is `Int.max`.
///   - maxItems: The maximum number of elements for which to write the full contents. The default is `Int.max`.
public func dumpOutput(_ value: Any, name: String? = nil, indent: Int = 0, maxDepth: Int = .max, maxItems: Int = .max) -> String {
	var output = ""
	dump(value, to: &output, name: name, indent: indent, maxDepth: maxDepth, maxItems: maxItems)
	return output
}
