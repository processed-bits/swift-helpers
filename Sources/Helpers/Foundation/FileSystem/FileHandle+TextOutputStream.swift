// FileHandle+TextOutputStream.swift, 29.01.2022-12.02.2025.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import Foundation

#if compiler(>=6.0)
	/// `TextOutputStream` conformance.
	extension FileHandle: @retroactive TextOutputStream {
		public func write(_ string: String) {
			_write(string)
		}
	}
#else
	extension FileHandle: TextOutputStream {
		public func write(_ string: String) {
			_write(string)
		}
	}
#endif

private extension FileHandle {
	// swiftlint:disable:next identifier_name
	func _write(_ string: String) {
		let data = Data(string.utf8)
		if #available(iOS 13.4, macOS 10.15.4, macCatalyst 13.4, tvOS 13.4, visionOS 1.0, watchOS 6.2, *) {
			try? write(contentsOf: data)
		} else {
			write(data)
		}
	}
}
