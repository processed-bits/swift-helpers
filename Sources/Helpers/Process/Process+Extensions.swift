// Process+Extensions.swift, 23.03.2023.
// Copyright © 2023 Stanislav Lomachinskiy.

import Foundation

public extension Process {

	// MARK: Creating a Shell Script Process Object

	/// Returns a process object initialized with a shell script.
	///
	/// - Parameters:
	///   - shellPath: A path to the shell interpreter. The default is `/bin/sh`.
	///   - shellArguments: Arguments for the shell interpreter to read and execute a script. The default is `["-c"]`.
	///   - script: A shell script to execute.
	///   - scriptArguments: Script arguments, if any.
	convenience init(shell shellPath: String = "/bin/sh", shellArguments: [String] = ["-c"], script: String, scriptArguments: [String] = []) {
		self.init()
		if #available(macOS 13.0, *) {
			executableURL = URL(filePath: shellPath)
		} else {
			executableURL = URL(fileURLWithPath: shellPath)
		}
		arguments = shellArguments + [script] + scriptArguments
	}

	// MARK: Running and Stopping a Process

	/// Runs the process with the current environment and returns when it is finished.
	@available(macOS 10.15, *)
	func runUntilExit() async throws {
		try run()
		waitUntilExit()
	}

}
