// CLI.swift, 16.02.2020-25.04.2023.
// Copyright © 2020-2023 Stanislav Lomachinskiy.

import Foundation

/// `CLI` namespace provides support for command-line interface standard error output.
///
/// Helper function is provided in the global scope:
///
/// - ``print(_:separator:terminator:to:)``, that takes an `OutputStreamKind` value as the `to` argument;
public enum CLI {

	/// The file handle associated with the standard error file.
	///
	/// In comparison to [`FileHandle.standardError`](https://developer.apple.com/documentation/foundation/filehandle/1411001-standarderror) property, this one is a stored property.
	///
	/// Together with conformance to [`TextOutputStream`](https://developer.apple.com/documentation/swift/textoutputstream) protocol this allows using [`print(_:separator:terminator:to:)`](https://developer.apple.com/documentation/swift/print(_:separator:terminator:to:)) with this handle as a target.
	public static var standardError = FileHandle.standardError

}
