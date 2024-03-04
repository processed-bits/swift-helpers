// NSManagedObject+Extensions.swift, 16.01.2021-23.03.2024.
// Copyright © 2021-2024 Stanislav Lomachinskiy.

#if canImport(CoreData)
	import CoreData

	public extension NSManagedObject {

		/// Returns the entity description that is associated with this subclass in the specified managed object context.
		///
		/// This method is only legal to call on subclasses of `NSManagedObject` that represent a single entity in the model.
		///
		///	This method correctly disambiguates entities while [`entity()`](https://developer.apple.com/documentation/coredata/nsmanagedobject/1640588-entity) is unable to disambiguate when Core Data loads a model more than once.
		class func entity(in context: NSManagedObjectContext) -> NSEntityDescription? {
			let entityName = String(describing: Self.self)
			return NSEntityDescription.entity(forEntityName: entityName, in: context)
		}

		/// Initializes a managed object subclass and inserts it into the specified managed object context.
		///
		/// This method is only legal to call on subclasses of `NSManagedObject` that represent a single entity in the model.
		///
		///	This method correctly disambiguates entities while [`init(context:)`](https://developer.apple.com/documentation/coredata/nsmanagedobject/1640602-init) is unable to disambiguate when Core Data loads a model more than once.
		///
		/// - Parameters:
		///   - context: The context into which the new instance is inserted.
		convenience init?(insertInto context: NSManagedObjectContext) {
			guard let entity = Self.entity(in: context) else {
				return nil
			}
			self.init(entity: entity, insertInto: context)
		}

	}
#endif
