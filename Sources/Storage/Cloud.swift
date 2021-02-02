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
@dynamicMemberLookup
@propertyWrapper
public final class Cloud<Value>:
  DynamicProperty,
  ObservableObject
where Value: CloudEntity {
  @Published
  var container: CloudContainer = .base {
    willSet { objectWillChange.send() }
  }
  let path: WritableKeyPath<CloudContainer, [Value]>
  public var wrappedValue: [Value] {
    get { container[keyPath: path] }
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

  public subscript(
    dynamicMember _: WritableKeyPath<CloudContainer, [Value]>
  ) -> [Value] {
    get { wrappedValue }
    set { wrappedValue = newValue }
  }

  public init(
    wrappedValue: [Value] = [],
    _ path: WritableKeyPath<CloudContainer, [Value]>
  ) {
    self.path = path
    guard self.container[keyPath: path].isEmpty else { return }
    self.wrappedValue = wrappedValue
  }
}
