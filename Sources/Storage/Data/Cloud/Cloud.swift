//
//  File.swift
//
//
//  Created by neutralradiance on 11/25/20.
//

import SwiftUI
import Unwrap

@propertyWrapper
public struct Cloud<Value>: DynamicProperty
where Value: CloudEntity, Value: Infallible {
  public let path: KeyPath<Value.Container, Value?>
  public var wrappedValue: Value? {
    get {
      Value.Container.shared[Value.self] ??
        Value.defaultValue
    }
    set {
      Value.Container.shared[Value.self] = newValue
    }
  }

  public var projectedValue: Binding<Value?> {
    Binding<Value?>(
      get: { wrappedValue },
      set: {
        Value.Container.shared[Value.self] = $0
      }
    )
  }

  public init(
    wrappedValue _: Value = Value.defaultValue,
    _ path: KeyPath<Value.Container, Value?>
  ) {
    self.path = path
  }
}
