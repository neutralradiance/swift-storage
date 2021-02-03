//
//  File.swift
//
//
//  Created by neutralradiance on 11/27/20.
//

import CoreData

public protocol CloudEntity: NSManagedObject {}

@available(iOS 13, macOS 10.15, *)
public extension CloudEntity {
  static subscript(
    for container: CloudContainer = .base
  ) -> [Self] {
    get { container[Self.self] }
    set { container[Self.self] = newValue }
  }

  static subscript(
    _ value: Self,
    for container: CloudContainer
  ) -> Self? {
    get { Self[for: container].first(where: { $0 == value }) }
    set {
      let context = container.container.viewContext
      if let value = newValue {
        context.insert(value)
      } else {
        context.delete(value)
      }
    }
  }
}
