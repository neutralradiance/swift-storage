//
//  File.swift
//
//
//  Created by neutralradiance on 11/25/20.
//

import SwiftUI
import CoreData

@dynamicMemberLookup
@propertyWrapper
public struct Cloud<Value>: DynamicProperty where Value: NSManagedObject {
    let container: CloudContainer
    let path: WritableKeyPath<CloudContainer, Set<Value>>

    public var wrappedValue: Set<Value> {
        get { container[keyPath: path] }
        nonmutating set { container[Value.self].formUnion(newValue) }
    }

    public var projectedValue: Binding<Set<Value>> {
        Binding<Set<Value>>(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 }
        )
    }

    public subscript(dynamicMember member: WritableKeyPath<CloudContainer, Set<Value>>) -> Set<Value> {
        get { self.wrappedValue }
        set { self.wrappedValue = newValue }
    }
//    @inlinable init(wrappedValue: [Value] = [], key: Key) {
//        self.key = key
//        guard CloudContainer.shared[key].isEmpty else { return }
//        self.wrappedValue = wrappedValue
//    }
    public init(wrappedValue: Set<Value> = [],
                _ path: WritableKeyPath<CloudContainer, Set<Value>>, container: CloudContainer = .base, inMemory: Bool? = nil) {
        self.container = container
        if let inMemory = inMemory {
            container.inMemory = inMemory
        }
        self.path = path
        guard container[keyPath: path].isEmpty else { return }
        self.wrappedValue = wrappedValue
    }
}
