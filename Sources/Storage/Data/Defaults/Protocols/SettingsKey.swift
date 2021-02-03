//
//  SettingsKey.swift
//  Stuffed
//
//  Created by neutralradiance on 1/29/21.
//

import Foundation
import Unwrap

public protocol SettingsKey: Hashable, CustomStringConvertible {
  associatedtype Value: Hashable
  static var defaultValue: Value { get }
  init()
}

public extension SettingsKey {
  var description: String {
    String(describing: Self.self)
  }
}

public extension SettingsKey where Value: Infallible {
  static var defaultValue: Value { .defaultValue }
}
