// Comment+Shared.swift, 12.03.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

#if canImport(Testing)
	import Testing

	package extension Comment {
		static let concurrency: Self = "Concurrency expectations may fail during parallelized tests or on shared runners."
		static let performance: Self = "Performance expectations may fail during parallelized tests or on shared runners."
	}
#endif
