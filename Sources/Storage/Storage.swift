//
//  Storage.swift
//
//
//  Created by neutralradiance on 10/25/20.
//

import SwiftUI
import Unwrap

/// A `UserDefaults` wrapper that automatically unwraps objects that conform to `CustomCodable``
/// This makes sure the stored properties you want to have default values for never return `nil`.
@propertyWrapper
public struct Storage<Value: CustomCodable>: DefaultsWrapper where Value: Infallible {

    public var store: UserDefaults = .standard
    public let key: String

    public var wrappedValue: Value {
        get {
            do {
                guard let data =
                        store.object(forKey: key) as? Value.Decoder.Input else {
                    return Value.defaultValue
                }

                return try Value.decoder.decode(Value.self, from: data)
            } catch {
                debugPrint(Error<Value>.read(description: error.localizedDescription))
            }
            return Value.defaultValue
        }
        nonmutating set {
            do {
                let data = try Value.encoder.encode(newValue)
                store.set(data, forKey: key)
            } catch {
                debugPrint(Error<Value>.write(description: error.localizedDescription))
            }
        }
    }

    public var projectedValue: Binding<Value> {
        Binding<Value>(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 }
        )
    }

    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) {
        self.key = key
        if let store = store { self.store = store }
        if self.store.object(forKey: key) == nil {
            self.wrappedValue = wrappedValue
        }
    }

}

// MARK: - Error-Handling
extension Storage {
    enum Error<Value>: LocalizedError {
        case read(description: String), write(description: String)

        static var prefix: String { "Storage.\(Self.self): " }

        var failureReason: String? {
            switch self {
                case let .read(description):
                    return description
                case let .write(description):
                    return description
            }
        }

        var errorDescription: String? {
            switch self {
                case .read:
                    return "Read."+Self.prefix.appending(failureReason!)
                case .write:
                    return "Write."+Self.prefix.appending(failureReason!)
            }
        }
    }
}
