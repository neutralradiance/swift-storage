//
//  Setting.swift
//  Stuffed
//
//  Created by neutralradiance on 1/29/21.
//

import Foundation
import SwiftUI

@propertyWrapper
public final class Setting<K>:
  DynamicProperty,
  ObservableObject
where K: SettingsKey {
  let path: KeyPath<Settings, K>
  @Published
  public var settings: Settings = .shared {
    willSet { objectWillChange.send() }
  }
  public var wrappedValue: K.Value {
    get {
      return settings[K.self]
    }
    set { settings[K.self] = newValue }
  }

  public var projectedValue: Binding<K.Value> {
    Binding<K.Value>(
      get: { self.wrappedValue },
      set: { [weak self] in
        self?.settings[K.self] = $0
      }
    )
  }

  public init(
    wrappedValue: K.Value = K.defaultValue,
    _ path: KeyPath<Settings, K>
  ) where K: SettingsKey {
    self.path = path
  }
}
