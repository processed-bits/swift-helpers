// FileHandle+TextOutputStream.swift, 29.01.2022.
// Copyright © 2022 Stanislav Lomachinskiy.

import Foundation

extension FileHandle: TextOutputStream {

	public func write(_ string: String) {
		let data = Data(string.utf8)
		if #available(macOS 10.15.4, *) {
			try? write(contentsOf: data)
		} else {
			write(data)
		}
	}

}
