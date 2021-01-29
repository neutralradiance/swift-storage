//
//  Cache.swift
//
//
//  Created by neutralradiance on 10/24/20.
//

import SwiftUI

/// A static / dynamic cache for objects that comform to `Cacheable`
///
/// - parameter : `Value` for caching
/// - parameter : `wrappedValue: [Value]` the initial components to be cached
@propertyWrapper
public struct Cache<Value: Cacheable>:
	SerializedCache & CacheWrapper where Value.ID == UUID {
	public var wrappedValue: [Value] {
		get {
			do {
				if let data = try? Self.dataContents() {
					return try Value.decoder
						.decode(Value.self, fromArray: data)
				}
			} catch {
				debugPrint(
					Error<Value>.read(
						description:
						error.localizedDescription
					).localizedDescription
				)
			}
			return []
		}
		nonmutating set {
			do {
				// clear cache if array is empty
				if newValue.isEmpty {
					try clear()
				} else {
					try Self.subtract(newValue)
				}
			} catch {
				debugPrint(
					Error<Value>.write(
						description:
						error.localizedDescription
					).localizedDescription
				)
			}
		}
	}
	
	@available(iOS 13.0, *)
	public var projectedValue: Binding<[Value]> {
		Binding<[Value]>(
			get: { self.wrappedValue },
			set: { self.wrappedValue = $0 }
		)
	}

	public init() {}
}

public extension Cache {
	/// Intializes a serialized cache that is encapsulated by a property wrapper.
	init(wrappedValue: [Value] = []) {
		self = Self.shared
		try? Self.add(wrappedValue)
	}

	/// An automatically determined name for the cache folder
	/// based on the associated type `Value`.
	static var key: String { String(describing: Value.self) }

	// MARK: - Subscripting

	/// A subscript for looking up and setting a `Value`
	/// that comforms to `AutoCodable` & `Identifiable`.
	/// - parameter id: The object's UUID for decoding and encoding.
	static subscript(id: Value.ID) -> Value? {
		get {
			do {
				// read the data from the cache
				if let data = try? getData(fileURL(id)) {
					// decode the data if valid
					return try Value.decoder.decode(Value.self, from: data)
				}
			} catch {
				debugPrint(
					Error<Value>.read(
						description:
						error.localizedDescription
					).localizedDescription
				)
			}
			return nil
		}
		set {
			do {
				guard newValue != nil else { // or invalid
					try fileManager.removeItem(at: fileURL(id))
					return
				}
				// ensure the file doesn't exist
				guard try !fileExists(fileURL(id)) else { return }

				// encode the data
				let data = try Value.encoder.encode(newValue)

				// create the cache if needed
				try Self.folder(createIfNeeded: true)

				// write the data to the cache
				try data.write(to: fileURL(id))
			} catch {
				debugPrint(
					Error<Value>.write(
						description: error.localizedDescription
					).localizedDescription
				)
			}
		}
	}
}

// MARK: - Error-Handling

extension Cache {
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
				return "Read." + Self.prefix.appending(failureReason!)
			case .write:
				return "Write." + Self.prefix.appending(failureReason!)
			}
		}
	}
}
