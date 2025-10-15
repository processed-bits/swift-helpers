// LegacyLoggerTests.swift, 11.02.2023.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

#if canImport(os.log)
	import LoggingHelpers
	import Testing

	struct LegacyLoggerTests {

		let logger = LegacyLogger()

		@Test func typeName() {
			let result = String(reflecting: LegacyLogger.self)
			#expect(result == "LoggingHelpers.LegacyLogger")
		}

		@Test func point() {
			logger.point()
			logger.debug("\(String.filePoint()): Test")
		}

	}
#endif
