// NSManagedObjectContext+Extensions.swift, 24.07.2019-03.12.2022.
// Copyright © 2019-2022 Stanislav Lomachinskiy.

import Cocoa

public extension NSManagedObjectContext {

	// MARK: Creating a Context

	/// Creates a context that uses the specified concurrency type and persistent store coordinator.
	///
	/// - Parameters:
	///   - concurrencyType: The context’s concurrency type. For possible values, see [`NSManagedObjectContext.ConcurrencyType`](https://developer.apple.com/documentation/coredata/nsmanagedobjectcontext/concurrencytype).
	///   - persistentStoreCoordinator: The persistent store coordinator of the context.
	@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
	convenience init(concurrencyType: ConcurrencyType, persistentStoreCoordinator: NSPersistentStoreCoordinator) {
		self.init(concurrencyType)
		self.persistentStoreCoordinator = persistentStoreCoordinator
	}

	/// Creates a context that uses the specified concurrency type and persistent store coordinator.
	///
	/// - Parameters:
	///   - concurrencyType: The context’s concurrency type. For possible values, see [`NSManagedObjectContextConcurrencyType`](https://developer.apple.com/documentation/coredata/nsmanagedobjectcontextconcurrencytype).
	///   - persistentStoreCoordinator: The persistent store coordinator of the context.
	@available(iOS, introduced: 5.0, deprecated: 15.0)
	@available(macOS, introduced: 10.7, deprecated: 12.0)
	@available(tvOS, introduced: 9.0, deprecated: 15.0)
	@available(watchOS, introduced: 2.0, deprecated: 8.0)
	convenience init(concurrencyType: NSManagedObjectContextConcurrencyType, persistentStoreCoordinator: NSPersistentStoreCoordinator) {
		self.init(concurrencyType: concurrencyType)
		self.persistentStoreCoordinator = persistentStoreCoordinator
	}

	/// Creates a context that uses the specified concurrency type and persistent store coordinator.
	///
	/// - Parameters:
	///   - concurrencyType: The context’s concurrency type. For possible values, see [`NSManagedObjectContext.ConcurrencyType`](https://developer.apple.com/documentation/coredata/nsmanagedobjectcontext/concurrencytype).
	///   - parent: The parent of the context.
	@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
	convenience init(concurrencyType: ConcurrencyType, parent: NSManagedObjectContext) {
		self.init(concurrencyType)
		self.parent = parent
	}

	/// Creates a context that uses the specified concurrency type and persistent store coordinator.
	///
	/// - Parameters:
	///   - concurrencyType: The context’s concurrency type. For possible values, see [`NSManagedObjectContextConcurrencyType`](https://developer.apple.com/documentation/coredata/nsmanagedobjectcontextconcurrencytype).
	///   - parent: The parent of the context.
	@available(iOS, introduced: 5.0, deprecated: 15.0)
	@available(macOS, introduced: 10.7, deprecated: 12.0)
	@available(tvOS, introduced: 9.0, deprecated: 15.0)
	@available(watchOS, introduced: 2.0, deprecated: 8.0)
	convenience init(concurrencyType: NSManagedObjectContextConcurrencyType, parent: NSManagedObjectContext) {
		self.init(concurrencyType: concurrencyType)
		self.parent = parent
	}

	// MARK: Handling Managed Objects

	/// Specifies objects with the specified fetch request that should be removed from its persistent store when changes are committed.
	///
	/// - Parameters:
	///   - fetchRequest: The description of search criteria used to retrieve data from the persistent store.
	func delete<T: NSManagedObject>(fetchRequest: NSFetchRequest<T>) throws {
		fetchRequest.includesPropertyValues = false
		let objects = try fetchRequest.execute()
		objects.forEach { delete($0) }
	}

	// MARK: Managing Unsaved and Uncommitted Changes

	/// If the context has uncommitted changes, attempts to commit unsaved changes to registered objects to the context’s parent store.
	func saveChanges() throws {
		guard hasChanges else {
			return
		}
		try save()
	}

	/// Commits unsaved changes to registered objects to the context’s parent store or prints a given message and stops execution.
	///
	/// - Parameters:
	///   - message: The string to print, may be `nil`.
	func save(orFatalError message: String? = nil, file: StaticString = #file, line: UInt = #line) {
		do {
			try save()
		} catch {
			fatalError(message ?? "Failed to save context: \(error.localizedDescription)")
		}
	}

	/// If the context has uncommitted changes, commits unsaved changes to registered objects to the context’s parent store or prints a given message and stops execution.
	///
	/// - Parameters:
	///   - message: The string to print, may be `nil`.
	func saveChanges(orFatalError message: String? = nil, file: StaticString = #file, line: UInt = #line) {
		guard hasChanges else {
			return
		}
		save(orFatalError: message, file: #file, line: #line)
	}

}
