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

extension SettingsKey {
  public var description: String {
    return String(describing: Self.self)
  }
}

extension SettingsKey where Value: Infallible {
  public static var defaultValue: Value { return .defaultValue }
}
