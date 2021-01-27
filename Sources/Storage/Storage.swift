//
//  Storage.swift
//
//
//  Created by neutralradiance on 10/25/20.

import SwiftUI
import Unwrap

/// A non-failiable wrapper for `UserDefaults`
@propertyWrapper
public struct Storage<Value>: DefaultsWrapper where Value: Infallible {
	public var store: UserDefaults = .standard
	public let key: String
	public var wrappedValue: Value {
		get { (store.object(forKey: key) as? Value).unwrap }
		nonmutating set { store.set(newValue, forKey: key) }
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
