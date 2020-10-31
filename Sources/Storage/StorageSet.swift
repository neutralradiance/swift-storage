//
//  SetStorage.swift
//
//
//  Created by neutralradiance on 10/25/20.
//

import SwiftUI
import Unwrap

extension Storage {
    /// A `UserDefaults` wrapper for any array of objects that conform to `CustomCodable`.
    /// If no value is found it simply returns an empty array instead of `nil`
@propertyWrapper
    public struct Set: DefaultsWrapper {
        public var store: UserDefaults = .standard
        public let key: String

        public var wrappedValue: [Storage.Value] {
            get {
                do {
                    if let data = store.object(forKey: key) as? [Storage.Value.Decoder.Input] {
                        return try Storage.Value.decoder.decode(Storage.Value.self, fromArray: data)
                    }
                    return []
                } catch {
                    debugPrint(Error<Storage.Set.Value>.read(description: error.localizedDescription))
                }
                return []
            }
            nonmutating set {
                do {
                    let data = try Storage.Value.encoder.encode(set: newValue)
                    store.set(data, forKey: key)
                } catch {
                    debugPrint(Error<Storage.Set.Value>.write(description: error.localizedDescription))
                }
            }
        }

        public var projectedValue: Binding<[Storage.Value]> {
            Binding<[Storage.Value]>(
                get: { self.wrappedValue },
                set: { self.wrappedValue = $0 }
            )
        }

        public init(wrappedValue: [Storage.Value], _ key: String, store: UserDefaults? = nil) {
            self.key = key
            if let store = store { self.store = store }
            if self.store.object(forKey: key) == nil {
                self.wrappedValue = wrappedValue
            }
        }
    }
}
