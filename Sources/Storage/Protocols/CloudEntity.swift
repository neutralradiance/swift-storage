//
//  File.swift
//  
//
//  Created by neutralradiance on 11/27/20.
//

import CoreData

public protocol CloudEntity: NSManagedObject {}

public extension CloudEntity {
    static var key: CloudKey<Self> {
        CloudKey<Self>()
    }
    static var _store: Cloud<Self> {
        Cloud<Self>(\.[key])
    }

    static var store: Set<Self> {
        get { _store.wrappedValue }
        set { _store.wrappedValue = newValue }
    }

    static subscript(_ value: Self.Type) -> Self? {
        get { Self.store.first(where: { $0 === value }) }
        set {
            // if existing
            if let existing = store.first(where: { $0 === value }) {
                if let value = newValue { store.insert(value) } else {
                    store.remove(existing)
                }
                // if non-existent
            } else if let value = newValue {
                store.insert(value)
            }
        }
    }
}
