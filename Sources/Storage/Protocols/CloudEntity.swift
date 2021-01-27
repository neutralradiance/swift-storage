//
//  File.swift
//
//
//  Created by neutralradiance on 11/27/20.
//

import CoreData

public protocol CloudEntity: NSManagedObject {}

public extension CloudEntity {
	static var key: CloudKey<Self> {
		CloudKey<Self>()
	}

	static func _store(
		for container: CloudContainer = .base
	) -> Cloud<Self> {
		Cloud<Self>(\.[key], container: container)
	}

	static subscript(
		for container: CloudContainer = .base
	) -> [Self] {
		get { _store(for: container).wrappedValue }
		set { _store(for: container).wrappedValue = newValue }
	}

	static subscript(
		_ value: Self,
		for container: CloudContainer
	) -> Self? {
		get { Self[for: container].first(where: { $0 == value }) }
		set {
			let context = container.container.viewContext
			if let value = newValue {
				context.insert(value)
			} else {
				context.delete(value)
			}
		}
	}
}
