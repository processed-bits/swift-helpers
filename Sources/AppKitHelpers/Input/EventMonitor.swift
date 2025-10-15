// EventMonitor.swift, 26.03.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy. All rights reserved.

#if os(macOS)
	import AppKit

	/// Event monitor, a wrapper for `NSEvent`’s app monitoring methods.
	public final class EventMonitor {

		private let mask: NSEvent.EventTypeMask
		private let globalBlock: ((NSEvent) -> Void)?
		private let localBlock: ((NSEvent) -> NSEvent?)?

		private var monitor: Any?

		// MARK: Life Cycle

		/// Creates an event monitor that receives copies of events posted to other applications.
		///
		/// Events are delivered asynchronously to your app and you can only observe the event; you cannot modify or otherwise prevent the event from being delivered to its original target application.
		///
		/// Key-related events may only be monitored if accessibility is enabled or if your application is trusted for accessibility access (see [`AXIsProcessTrusted()`](https://developer.apple.com/documentation/applicationservices/1460720-axisprocesstrusted)).
		///
		/// Note that your handler will not be called for events that are sent to your own application.
		///
		/// - Parameters:
		///   - mask: An event mask specifying which events you wish to monitor. See [`NSEvent.EventTypeMask`](https://developer.apple.com/documentation/appkit/nsevent/eventtypemask) for possible values.
		///   - block: The event handler block object. It is passed the event to monitor. You are unable to change the event, merely observe it.
		public static func global(
			mask: NSEvent.EventTypeMask,
			handler block: @escaping (NSEvent) -> Void
		) -> Self {
			self.init(mask: mask, globalBlock: block)
		}

		/// Creates an event monitor that receives copies of events posted to this application before they are dispatched.
		///
		/// Your handler will not be called for events that are consumed by nested event-tracking loops such as control tracking, menu tracking, or window dragging; only events that are dispatched through the application’s [`sendEvent(_:)`](https://developer.apple.com/documentation/appkit/nsapplication/1428359-sendevent) method will be passed to your handler.
		///
		/// - Note: See [`addLocalMonitorForEvents(matching:handler:)`](https://developer.apple.com/documentation/appkit/nsevent/1534971-addlocalmonitorforevents) for further details.
		///
		/// - Parameters:
		///   - mask: An event mask specifying which events you wish to monitor. See [`NSEvent.EventTypeMask`](https://developer.apple.com/documentation/appkit/nsevent/eventtypemask) for possible values.
		///   - block: The event handler block object. It is passed the event to monitor. You can return the event unmodified, create and return a new NSEvent object, or return nil to stop the dispatching of the event.
		public static func local(
			mask: NSEvent.EventTypeMask,
			handler block: @escaping (NSEvent) -> NSEvent?
		) -> Self {
			self.init(mask: mask, localBlock: block)
		}

		private init(
			mask: NSEvent.EventTypeMask,
			globalBlock: ((NSEvent) -> Void)? = nil,
			localBlock: ((NSEvent) -> NSEvent?)? = nil
		) {
			self.mask = mask
			self.globalBlock = globalBlock
			self.localBlock = localBlock
		}

		deinit {
			stop()
		}

		// MARK: Starting and Stopping

		/// Start (install) the event monitor.
		public func start() {
			guard monitor == nil else {
				return
			}
			if let globalBlock {
				monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: globalBlock)
			} else if let localBlock {
				monitor = NSEvent.addLocalMonitorForEvents(matching: mask, handler: localBlock)
			}
		}

		/// Stop (remove) the event monitor.
		public func stop() {
			if let monitor {
				NSEvent.removeMonitor(monitor)
			}
			monitor = nil
		}

	}
#endif
