// LoggerTests.swift, 15.11.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

#if canImport(os.log)
	import LoggingHelpers
	import os.log
	import Testing

	struct LoggerTests {

		let logger = Logger()

		@Test func typeName() {
			let result = String(reflecting: Logger.self)
			#expect(result == "os.Logger")
		}

		@Test func point() {
			logger.point()
			logger.debug("\(String.filePoint()): Test")
		}

	}
#endif
