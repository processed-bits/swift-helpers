// NSResponder+Extensions.swift, 08.12.2020-02.12.2022.
// Copyright © 2020-2022 Stanislav Lomachinskiy.

import Cocoa

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
