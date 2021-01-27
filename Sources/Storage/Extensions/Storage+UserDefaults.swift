//
//  Storage+UserDefaults.swift
//
//
//  Created by neutralradiance on 10/20/20.
//

import Foundation

public extension UserDefaults {
	func clearAll() {
		dictionaryRepresentation().keys
			.forEach { removeObject(forKey: $0) }
	}
}
