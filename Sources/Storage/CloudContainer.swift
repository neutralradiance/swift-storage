//
//  CloudContainer.swift
//  _Name
//
//  Created by neutralradiance on 11/17/20.
//

import CoreData
import SwiftUI

public class CloudContainer: ObservableObject {
	@Published public var isLoading: Bool = false
	public var shouldReset: Bool
	public var name: String
	public var inMemory: Bool

	private func load(_ perform: (() -> Void)? = nil) {
		isLoading = true
		perform?()
		isLoading = false
	}

	public lazy var container: NSPersistentCloudKitContainer = {
		let container =
			NSPersistentCloudKitContainer(name: name)
		// if shouldReset {}
		load {
			if self.inMemory {
				container.persistentStoreDescriptions.first!.url =
					URL(fileURLWithPath: "/dev/null")
			}
			container.loadPersistentStores(
				completionHandler: { _, error in
					if let error = error as NSError? {
						fatalError(
							"Unresolved error \(error), \(error.userInfo)"
						)
					}
				}
			)
			container.viewContext
				.automaticallyMergesChangesFromParent = true
			container.viewContext.mergePolicy =
				NSMergeByPropertyObjectTrumpMergePolicy
		}
		return container
	}()

	public subscript<T>(
		_: T.Type
	) -> [T] where T: CloudEntity {
		get {
			var results: [T] = []
			load {
				if let fetchRequest =
					T.fetchRequest() as? NSFetchRequest<T>
				{
					let context = self.container.viewContext
					do {
						results = try context.fetch(fetchRequest)
					} catch {
						debugPrint(error.localizedDescription)
					}
				}
			}
			return results
		}
		set {
			load {
				do {
					// TODO: Improve implementation to delete, insert, etc.
					try self.container.viewContext.save()
				} catch {
					debugPrint(error.localizedDescription)
				}
			}
		}
	}

	public subscript<T>(
		_: CloudKey<T>
	) -> [T] where T: CloudEntity {
		get { self[T.self] }
		set { self[T.self] = newValue }
	}

	public init(
		inMemory: Bool = false,
		shouldReset: Bool = false,
		named name: String = "BaseModel"
	) {
		self.shouldReset = shouldReset
		self.inMemory = inMemory
		self.name = name
	}
}

public extension CloudContainer {
	static let base = CloudContainer()
}
