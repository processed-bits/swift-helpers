// Process+Extensions.swift, 23.03.2023.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

#if os(macOS) || targetEnvironment(macCatalyst)
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
		convenience init(
			shell shellPath: String = "/bin/sh",
			shellArguments: [String] = ["-c"],
			script: String,
			scriptArguments: [String] = []
		) {
			self.init()
			if #available(macOS 13.0, macCatalyst 16.0, *) {
				executableURL = URL(filePath: shellPath, directoryHint: .notDirectory)
			} else {
				executableURL = URL(fileURLWithPath: shellPath, isDirectory: false)
			}
			arguments = shellArguments + [script] + scriptArguments
		}

		// MARK: Running and Stopping a Process

		/// Runs the process with the current environment in an asynchronous task.
		@available(macOS 10.15, *)
		func runUntilExit() async throws {
			// Prevent blocking the main thread or any important execution context.
			try await Task {
				try run()
				waitUntilExit()
			}.value
		}

	}
#endif
