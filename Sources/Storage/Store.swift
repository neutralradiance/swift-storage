//
//  Storage.swift
//
//
//  Created by neutralradiance on 10/25/20.
//

import SwiftUI
import Unwrap

/// A `UserDefaults` wrapper for object that conform to `AutoCodable``
@propertyWrapper
public struct Store<Value: AutoCodable>: DefaultsWrapper {
	public var store: UserDefaults = .standard
	public let key: String

	public var wrappedValue: Value? {
		get {
			do {
				guard let data =
					store.object(forKey: key) as? Data
				else {
					return nil
				}

				return try Value.decoder.decode(Value.self, from: data)
			} catch {
				debugPrint(
					Error<Value>.read(
						description: error.localizedDescription
					)
				)
			}
			return nil
		}
		nonmutating set {
			do {
				let data = try Value.encoder.encode(newValue)
				store.set(data, forKey: key)
			} catch {
				debugPrint(
					Error<Value>.write(
						description: error.localizedDescription)
				)
			}
		}
	}
	@available(iOS 13.0, *)
	public var projectedValue: Binding<Value?> {
		Binding<Value?>(
			get: { self.wrappedValue },
			set: { self.wrappedValue = $0 }
		)
	}

	public init(
		wrappedValue: Value? = nil,
		_ key: String, store: UserDefaults? = nil
	) {
		self.key = key
		if let store = store { self.store = store }
		if self.store.object(forKey: key) == nil {
			self.wrappedValue = wrappedValue
		}
		//        if let store = store { self.store = store }
		//        guard self.store.object(forKey: key) == nil else { return }
		//        self.wrappedValue = wrappedValue
	}

	public func update() {}
}

// MARK: - Error-Handling

extension Store {
	enum Error<Value>: LocalizedError {
		case read(description: String),
		     write(description: String)

		static var prefix: String { "\(Self.self): " }

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
				return "Read." + Self.prefix
					.appending(failureReason!)
			case .write:
				return "Write." + Self.prefix
					.appending(failureReason!)
			}
		}
	}
}

extension Store: AutoCodable {
	public init(from decoder: Decoder) throws {
		try self.init(from: decoder)
		if let data =
			store.data(forKey: key)
		{
			wrappedValue =
				try Self.decoder.decode(Value.self, from: data)
		}
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(wrappedValue)
	}

	public static var decoder: Value.AutoDecoder { Value.decoder }
	public static var encoder: Value.AutoEncoder { Value.encoder }
}
