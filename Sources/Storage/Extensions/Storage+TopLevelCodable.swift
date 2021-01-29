//
//  Storage+TopLevelCodable.swift
//
//
//  Created by neutralradiance on 10/24/20.
//

import Foundation

public extension JSONDecoder {
	func decode<T>(
		_ type: T.Type,
		fromArray array: [Data]
	) throws -> [T] where T: Decodable {
		try array.map { try self.decode(type, from: $0) }
	}
}

public extension JSONEncoder {
	func encode<T>(
		set: [T]
	) throws -> [Data] where T: Encodable {
		try set.map { try self.encode($0) }
	}
}
