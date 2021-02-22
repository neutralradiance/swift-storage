//
//  File.swift
//
//
//  Created by William Luke on 2/5/21.
//

import Foundation

public protocol CloudContainer: StateObservable {
  subscript<T>(of set: T.Type) -> [T]
    where T: CloudEntity { get set }
  subscript<T>(_: T.Type) -> T?
    where T: CloudEntity { get set }
  static var shared: Self { get }
}

public extension CloudContainer {
//  subscript<T>(of set: T.Type) -> [T]
//    where T: CloudEntity {
//    get { Self[of: T.Value.self] }
//    set { Self[of: T.Value.self] = newValue }
//  }
//  subscript<T>(_: T.Type) -> T.Value?
//    where T: CloudEntity {
//    get { Self[T.Value.self] }
//    set { Self[T.Value.self] = newValue }
//  }
}
