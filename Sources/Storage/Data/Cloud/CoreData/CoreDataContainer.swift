//
//  File.swift
//  
//
//  Created by William Luke on 2/5/21.
//

import CoreData

/*
public final class CoreDataContainer: CloudContainer {
  public typealias BaseClass = CoreDataObject
  @Published
  public var state: PublisherState = .initialize {
    willSet { objectWillChange.send() }
  }
  public var shouldReset: Bool
  public var inMemory: Bool
  public var key: String
  public lazy var container: NSPersistentCloudKitContainer = {
    let container =
      NSPersistentCloudKitContainer(name: key)
    // if shouldReset {}
    update(.initialize) {
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
  
  public subscript<BaseClass>(
    _: BaseClass.Type
  ) -> [BaseClass] {
    get {
      var results: [BaseClass] = []
      update(.load) {
        if let fetchRequest =
        BaseClass.fetchRequest() as? NSFetchRequest<BaseClass> {
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
      update(.change) {
         do {
          // TODO: Improve implementation to delete, insert, etc.
          try self.container.viewContext.save()
        } catch {
          debugPrint(error.localizedDescription)
        }
      }
    }
  }
  public init(
    inMemory: Bool = false,
    shouldReset: Bool = false,
    key: String = "Base"
  ) {
    self.shouldReset = shouldReset
    self.inMemory = inMemory
    self.key = key
  }
}
*/
