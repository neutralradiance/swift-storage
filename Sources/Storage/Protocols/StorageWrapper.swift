//
//  StorageWrapper.swift
//
//
//  Created by neutralradiance on 11/24/20.
//

import SwiftUI

public protocol StorageWrapper: BaseStorage, DynamicProperty {
	var wrappedValue: [Value] { get nonmutating set }
	var projectedValue: Binding<[Value]> { get }
}

public extension StorageWrapper where Value: Identifiable {
	subscript(_ id: Value.ID) -> Value? {
		get { wrappedValue.first(where: { $0.id == id }) }
		nonmutating set {
			// if existing
			if let index =
				self.wrappedValue.firstIndex(where: { $0.id == id })
			{
				if let value =
					newValue { self.wrappedValue[index] = value } else {
					self.wrappedValue.remove(at: index)
				}
				// if non-existent
			} else if let value = newValue {
				self.wrappedValue.append(value)
			}
		}
	}
}
