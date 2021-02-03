//
//  Storage+UserDefaults.swift
//
//
//  Created by neutralradiance on 10/20/20.
//

import Foundation

public extension UserDefaults {
  func reset() {
    dictionaryRepresentation().keys
      .forEach { removeObject(forKey: $0) }
  }
}

public extension UserDefaults {
  /// Gets value for key based on `Hashable` key values.
  func value<Key: SettingsKey>(for key: Key) -> Key.Value {
    value(forKey: key.description) as? Key.Value ?? Key.defaultValue
  }

  /// Sets value for key based on key values.
  func set<Key: SettingsKey>(_ value: Key.Value?, for key: Key) {
    setValue(value, forKey: key.description)
  }

  subscript<Key: SettingsKey>(_ key: Key.Type) -> Key.Value {
    get { value(for: key.init()) }
    set { set(newValue, for: key.init()) }
  }
}

public extension UserDefaults {
//  /// Gets value for key based on `Hashable` key values.
//  func value<Key: SettingsKey>(for key: Key) -> Key.Value {
//    value(forKey: key.description) as? Key.Value ?? Key.defaultValue
//  }
//
//  /// Sets value for key based on key values.
//  func set<Key: SettingsKey>(_ value: Key.Value?, for key: Key) {
//    setValue(value, forKey: key.description)
//  }
//
  func value<Key: SettingsKey>(for key: Key) -> Key.Value
  where Key.Value: AutoCodable {
    if let data =
      (value(forKey: key.description) as? Key.Value.AutoDecoder.Input),
      let value = try? Key.Value.decoder
      .decode(Key.Value.self, from: data) {
      return value
    }
    return Key.defaultValue
  }

  func set<Key: SettingsKey>(_ value: Key.Value?, for key: Key)
  where Key.Value: AutoCodable {
    try? setValue(value?.encoded(), forKey: key.description)
  }
}
