//
//  File.swift
//
//
//  Created by neutralradiance on 11/25/20.
//

import SwiftUI
import CoreData
import Algorithms

@dynamicMemberLookup
@propertyWrapper
public struct Cloud<Value>: DynamicProperty where Value: CloudEntity {
    let container: CloudContainer
    let path: WritableKeyPath<CloudContainer, [Value]>

    public var wrappedValue: [Value] {
        get { container[keyPath: path] }
        nonmutating set {
            container[Value.self] =
                container[Value.self]+newValue.uniqued()
        }
    }

    public var projectedValue: Binding<[Value]> {
        Binding<[Value]>(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 }
        )
    }

    public subscript(dynamicMember member: WritableKeyPath<CloudContainer, [Value]>) -> [Value] {
        get { self.wrappedValue }
        set { self.wrappedValue = newValue }
    }
    
    public init(wrappedValue: [Value] = [],
                _ path: WritableKeyPath<CloudContainer, [Value]>, container: CloudContainer = .base, inMemory: Bool? = nil) {
        self.container = container
        if let inMemory = inMemory {
            container.inMemory = inMemory
        }
        self.path = path
        guard container[keyPath: path].isEmpty else { return }
        self.wrappedValue = wrappedValue
    }
}
