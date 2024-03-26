// print.swift, 15.01.2023-23.03.2024.
// Copyright © 2023-2024 Stanislav Lomachinskiy.

/// Writes the textual representations of the given items into the given output stream.
///
/// - Parameters:
///   - items: Zero or more items to print.
///   - separator: A string to print between each item. The default is a single space `(" ")`.
///   - terminator: The string to print after all items have been printed. The default is a newline `("\n")`.
///   - streamKind: An output stream kind. The default is `.standardOutput`.
public func print(_ items: Any..., separator: String = " ", terminator: String = "\n", to streamKind: OutputStreamKind = .standardOutput) {
	switch streamKind {
	case .standardOutput:
		Swift.print(items, separator: separator, terminator: terminator)
	case .standardError:
		Swift.print(items, separator: separator, terminator: terminator, to: &CLI.standardError)
	}
}
