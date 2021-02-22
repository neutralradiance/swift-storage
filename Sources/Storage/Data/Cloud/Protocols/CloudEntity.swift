//
//  File.swift
//
//
//  Created by neutralradiance on 11/27/20.
//

import Foundation

public protocol CloudEntity {
  associatedtype Container: CloudContainer
  static var container: Container { get }
}

extension CloudEntity {
  public static var key: String {
    String(describing: Self.self)
  }
}

/*
public extension CloudEntity {
  static func fetch() -> [Self] {
    container[Self.self]
  }

  static subscript(_ value: Self) -> Self? {
    get { Self.fetch().first(where: { $0 == value }) }
    set {
      if let newValue = newValue {
        container[Self.self].append(newValue)
      } else {
        container[Self.self]
          .removeAll(where: { $0 == value })
      }
    }
  }

  static subscript(id: Self.ID) -> [Self]
    where Self: Identifiable {
    get {
      fetch().compactMap { object in
        guard object.id == id else { return nil }
        return object
      }
    }
    set {
      for (offset, object) in fetch().enumerated()
        where newValue.contains(where: { $0.id == object.id }) {
        container[Self.self].remove(at: offset)
        container[Self.self].insert(object, at: offset)
      }
    }
  }

  static subscript(id: Self.ID) -> Self?
    where Self: Identifiable {
    get {
      fetch().first(where: { $0.id == id })
    }
    set {
      for (offset, object) in fetch().enumerated()
        where object.id == id {
        if let newValue = newValue {
          container[Self.self].remove(at: offset)
          container[Self.self].insert(newValue, at: offset)
        } else {
          container[Self.self].remove(at: offset)
        }
      }
    }
  }
}

extension CloudEntity where Self: Equatable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine([id])
  }
  public static func == (lhs: Self, rhs: Self) -> Bool {
     lhs.id == rhs.id
   }
}
*/
