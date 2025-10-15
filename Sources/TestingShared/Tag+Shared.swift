// Tag+Shared.swift, 12.03.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

#if canImport(Testing)
	import Testing

	package extension Tag {
		@Tag static var concurrency: Self
		@Tag static var performance: Self
	}
#endif
