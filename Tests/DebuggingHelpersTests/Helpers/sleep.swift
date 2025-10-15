// sleep.swift, 08.03.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

/// Synchronously sleep with high precision for the given duration.
func sleep(for duration: Duration) {
	let clock = ContinuousClock()
	let start = clock.now

	while clock.now - start < duration {
		continue
	}
}
