// Condition.swift, 01.04.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

import Foundation

enum Condition {

	static let isLinux: Bool = {
		#if os(Linux)
			true
		#else
			false
		#endif
	}()

	static let isMacOS13: Bool = {
		#if os(macOS)
			if #available(macOS 13, *) {
				let version = ProcessInfo.processInfo.operatingSystemVersion
				return version.majorVersion == 13
			}
		#endif
		return false
	}()

	static let isMacOS15: Bool = {
		#if os(macOS)
			if #available(macOS 15, *) {
				let version = ProcessInfo.processInfo.operatingSystemVersion
				return version.majorVersion == 15
			}
		#endif
		return false
	}()

	// swiftlint:disable:next identifier_name
	static let isCompiler6_0: Bool = {
		#if compiler(>=6.0) && compiler(<6.1)
			true
		#else
			false
		#endif
	}()

	// swiftlint:disable:next identifier_name
	static let isCompiler6_1: Bool = {
		#if compiler(>=6.1) && compiler(<6.2)
			true
		#else
			false
		#endif
	}()

}
