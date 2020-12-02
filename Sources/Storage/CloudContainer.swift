//
//  CloudContainer.swift
//  _Name
//
//  Created by neutralradiance on 11/17/20.
//

import SwiftUI
import CoreData

public class CloudContainer: ObservableObject {
    @Published public var isLoading: Bool = false
    public var shouldReset: Bool
    public var name: String
    public var inMemory: Bool

    private func load(_ perform: (() -> Void)? = nil) {
        self.isLoading = true
        perform?()
        self.isLoading = false
    }

    public lazy var container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: name)
        if shouldReset { }
        load {
            if self.inMemory {
                container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            }
            container.loadPersistentStores(completionHandler: { (_, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
        return container
    }()

    public subscript<T>(key: T.Type) -> [T] where T: NSManagedObject {
        get {
            var results: [T] = []
            load {
                if let fetchRequest =  T.fetchRequest() as? NSFetchRequest<T> {
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
                    try self.container.viewContext.save()
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
    public subscript<T>(key: CloudKey<T>) -> [T] where T: NSManagedObject {
        get { self[T.self] }
        set { self[T.self] = newValue }
    }

    public init(inMemory: Bool = false, shouldReset: Bool = false, named name: String = "BaseModel") {
        self.shouldReset = shouldReset
        self.inMemory = inMemory
        self.name = name
    }
}

public extension CloudContainer {
    static let base: CloudContainer = CloudContainer()
}
