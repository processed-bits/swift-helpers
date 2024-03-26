// NSResponder+Extensions.swift, 08.12.2020-06.03.2024.
// Copyright © 2020-2024 Stanislav Lomachinskiy.

#if os(macOS)
	import AppKit

	public extension NSResponder {

		/// The responder chain starting from this responder.
		var responderChain: [NSResponder] {
			var chain: [NSResponder] = [self]
			while let responder = chain.last?.nextResponder {
				chain.append(responder)
			}
			return chain
		}

	}
#endif
