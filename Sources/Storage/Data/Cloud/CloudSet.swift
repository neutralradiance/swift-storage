//
//  File.swift
//
//
//  Created by William Luke on 2/7/21.
//

import SwiftUI

public extension Cloud {
  @propertyWrapper
  struct Set: StorageWrapper {
    public let path: KeyPath<Value.Container, [Value]>
    public var defaultValue: [Value]?
    public var wrappedValue: [Value] {
      get {
        let value = Value.Container.shared[of: Value.self]
        return value.isEmpty ? (defaultValue ?? value) : value
      }
      nonmutating set {
        Value.Container.shared[of: Value.self] = newValue
      }
    }

    public var projectedValue: Binding<[Value]> {
      Binding<[Value]>(
        get: { wrappedValue },
        set: { Value.Container.shared[of: Value.self] = $0 }
      )
    }

    public init(
      wrappedValue: [Value] = [],
      _ path: KeyPath<Value.Container, [Value]>
    ) {
      self.path = path
      if wrappedValue.isEmpty {
        defaultValue = wrappedValue
      }
    }
  }
}
