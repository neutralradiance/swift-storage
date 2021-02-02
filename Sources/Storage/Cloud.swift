//
//  File.swift
//
//
//  Created by neutralradiance on 11/25/20.
//

import Algorithms
import CoreData
import SwiftUI

@available(iOS 13, macOS 10.15, *)
@propertyWrapper
public final class Cloud<Value>:
  DynamicProperty,
  ObservableObject
where Value: CloudEntity {
  @Published
  var container: CloudContainer = .base {
    willSet { objectWillChange.send() }
  }
  let path: KeyPath<CloudContainer, CloudKey<Value>>
  public var wrappedValue: [Value] {
    get { container[Value.self] }
    set {
      container[Value.self] =
        container[Value.self] + newValue.uniqued()
    }
  }

  public var projectedValue: Binding<[Value]> {
    Binding<[Value]>(
      get: { self.wrappedValue },
      set: { self.wrappedValue = $0 }
    )
  }

  public init(
    wrappedValue: [Value] = [],
    _ path: KeyPath<CloudContainer, CloudKey<Value>>
  ) {
    self.path = path
    guard self.container[Value.self].isEmpty else { return }
    self.wrappedValue = wrappedValue
  }
}
