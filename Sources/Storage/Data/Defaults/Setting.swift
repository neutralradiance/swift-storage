//
//  Setting.swift
//  Stuffed
//
//  Created by neutralradiance on 1/29/21.
//

import Foundation
import SwiftUI

@propertyWrapper
public final class Setting<Key: SettingsKey>:
  DynamicProperty,
  ObservableObject {
  @Published
  public var settings: Settings = .shared {
    willSet { objectWillChange.send() }
  }

  public let path: KeyPath<Settings, Key>
  public let defaultValue: Key.Value?
  public var wrappedValue: Key.Value {
    get {
      let value = settings[path]
      return
        defaultValue == nil ?
        value :
        value == Key.defaultValue ?
        value : defaultValue!
    }
    set { settings[path] = newValue }
  }

  public var projectedValue: Binding<Key.Value> {
    Binding<Key.Value>(
      get: { self.wrappedValue },
      set: {
        self.settings[self.path] = $0
      }
    )
  }

  public init(
    wrappedValue: Key.Value? = .none,
    _ path: KeyPath<Settings, Key>
  ) {
    defaultValue = wrappedValue
    self.path = path
  }
}
