// LegacyLogger.swift, 11.01.2021.
// Copyright © 2021-2025 Stanislav Lomachinskiy.

#if canImport(os.log)
	import Foundation
	import os.log

	/// An object for writing interpolated string messages to the unified logging system using a legacy logging function.
	@available(iOS 10.0, macOS 10.12, macCatalyst 13.0, tvOS 10.0, watchOS 3.0, *)
	public struct LegacyLogger {

		private let osLog: OSLog

		// MARK: Creating a Logger

		/// Creates a logger that writes to the default subsystem.
		public init() {
			osLog = .default
		}

		/// Creates a logger using the specified subsystem and category.
		///
		/// - Parameters:
		///   - subsystem: The string that identifies the subsystem that emits signposts. Typically, you use the same value as your app’s *bundle ID*. For more information, see [`CFBundleIdentifier`](https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleidentifier).
		///   - category: The string that the system uses to categorize emitted signposts.
		public init(subsystem: String, category: String) {
			osLog = OSLog(subsystem: subsystem, category: category)
		}

		/// Creates a logger that writes to the specified log.
		///
		/// - Parameters:
		///   - logObj: The log to write messages to.
		public init(_ logObj: OSLog) {
			osLog = logObj
		}

		// MARK: Logging a Message

		/// Writes a message to the log.
		///
		/// - Parameters:
		///   - level: The message’s log level, which determines the severity of the message and whether the system persists it to disk. For possible values, see [OSLogType](https://developer.apple.com/documentation/os/oslogtype).
		///   - message: The interpolated string that the logger writes to the log.
		public func log(level: OSLogType = .debug, _ message: any StringProtocol) {
			os_log("%@", type: level, String(message))
		}

		// MARK: Logging a Scoped Message

		/// Writes a message to the log using the default log type.
		///
		/// - Parameters:
		///   - message: The interpolated string that the logger writes to the log.
		public func notice(_ message: any StringProtocol) {
			debug(message)
		}

		/// Writes a debug message to the log.
		///
		/// - Parameters:
		///   - message: The interpolated string that the logger writes to the log.
		public func debug(_ message: any StringProtocol) {
			log(level: .debug, message)
		}

		/// Writes a trace message to the log.
		///
		/// - Parameters:
		///   - message: The interpolated string that the logger writes to the log.
		public func trace(_ message: any StringProtocol) {
			debug(message)
		}

		/// Writes an informative message to the log.
		///
		/// - Parameters:
		///   - message: The interpolated string that the logger writes to the log.
		public func info(_ message: any StringProtocol) {
			log(level: .info, message)
		}

		/// Writes information about an error to the log.
		///
		/// - Parameters:
		///   - message: The interpolated string that the logger writes to the log.
		public func error(_ message: any StringProtocol) {
			log(level: .error, message)
		}

		/// Writes information about a warning to the log.
		///
		/// - Parameters:
		///   - message: The interpolated string that the logger writes to the log.
		public func warning(_ message: any StringProtocol) {
			error(message)
		}

		/// Writes a message to the log about a bug that occurs when your app executes.
		///
		/// - Parameters:
		///   - message: The interpolated string that the logger writes to the log.
		public func fault(_ message: any StringProtocol) {
			log(level: .fault, message)
		}

		/// Writes a message to the log about a critical event in your app’s execution.
		///
		/// - Parameters:
		///   - message: The interpolated string that the logger writes to the log.
		public func critical(_ message: any StringProtocol) {
			fault(message)
		}

	}
#endif
