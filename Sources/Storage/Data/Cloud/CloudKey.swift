//
//  File.swift
//
//
//  Created by neutralradiance on 11/25/20.
//

import CoreData

//public struct CloudKey<Value>: Hashable
//  where Value: CloudEntity {
//  public init() {}
//}
public protocol CloudKey {
  associatedtype Value: CloudEntity
  //static var defaultValue: Value { get }
}

