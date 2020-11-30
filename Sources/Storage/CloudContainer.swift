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

    public var name: String
    public var inMemory: Bool

    private func load(_ perform: (() -> Void)? = nil) {
        self.isLoading = true
        perform?()
        self.isLoading = false
    }

    public lazy var container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: name)
        load {
            if self.inMemory {
                container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            }
            /*
             The persistent container for the application. This implementation
             creates and returns a container, having loaded the store for the
             application to it. This property is optional since there are legitimate
             error conditions that could cause the creation of the store to fail.
             */
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
        return container
    }()

    public subscript<T>(key: T.Type) -> Set<T> where T: NSManagedObject {
        get {
            var results: Set<T> = []
            load {
                if let fetchRequest =  T.fetchRequest() as? NSFetchRequest<T> {
                    let context = self.container.viewContext
                    do {
                        results = try Set(context.fetch(fetchRequest))
                    }
                    catch {
                        debugPrint(error.localizedDescription)
                    }
                }
            }
            return results
        }
        set {
            load {
                do {
//                    if self.container.viewContext.hasChanges {
                    try self.container.viewContext.save()
//                    }
                }
                catch {
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
    public subscript<T>(key: CloudKey<T>) -> Set<T> where T: NSManagedObject {
        get { self[T.self] }
        set { self[T.self] = newValue }
    }

    public init(inMemory: Bool = false, name: String = "BaseModel") {
        self.inMemory = inMemory
        self.name = name
    }
}

public extension CloudContainer {
    static let base: CloudContainer = CloudContainer()
}

