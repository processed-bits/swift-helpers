// print.swift, 15.01.2023.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

import Foundation

/// Writes the textual representations of the given items into the given file handle.
///
/// - Parameters:
///   - items: Zero or more items to print.
///   - separator: A string to print between each item. The default is a single space (` `).
///   - terminator: The string to print after all items have been printed. The default is a newline (`\n`).
///   - handle: A file handle to receive the text representation of each item.
public func print(
	_ items: Any...,
	separator: String = " ",
	terminator: String = "\n",
	to handle: FileHandle
) {
	var handle = handle
	Swift.print(items, separator: separator, terminator: terminator, to: &handle)
}

/// Writes the textual representations of the given items into the output stream of the given kind.
///
/// - Parameters:
///   - items: Zero or more items to print.
///   - separator: A string to print between each item. The default is a single space (` `).
///   - terminator: The string to print after all items have been printed. The default is a newline (`\n`).
///   - streamKind: A kind of the output stream to receive the text representation of each item. The default is `.standardOutput`.
public func print(
	_ items: Any...,
	separator: String = " ",
	terminator: String = "\n",
	to streamKind: OutputStreamKind = .standardOutput
) {
	switch streamKind {
	case .standardOutput:
		Swift.print(items, separator: separator, terminator: terminator)
	case .standardError:
		print(items, separator: separator, terminator: terminator, to: FileHandle.standardError)
	}
}
