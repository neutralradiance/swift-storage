//
//  DefaultsWrapper.swift
//
//
//  Created by neutralradiance on 10/20/20.
//

import SwiftUI

/// A single / multiple value property wrapper for any `UserDefaults` storage.
public protocol DefaultsWrapper: DynamicProperty {
    associatedtype Value
    var store: UserDefaults { get set }
    var key: String { get }
    var wrappedValue: Value { get set }
    var projectedValue: Binding<Value> { get }
    init(wrappedValue: Value, _ key: String, store: UserDefaults?)
}

extension DefaultsWrapper {
    public func clear() {
        store.removeObject(forKey: key)
    }
}
