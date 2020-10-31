//
//  Storage+TopLevelCodable.swift
//
//
//  Created by neutralradiance on 10/24/20.
//

import Combine
import Foundation

public extension TopLevelDecoder {
    func decode<T>(_ type: T.Type, fromArray array: [Input]) throws -> [T] where T: Decodable {
       try array.map { try self.decode(type, from: $0) }
    }
}

public extension TopLevelEncoder {
    func encode<T>(set: [T]) throws -> [Output] where T: Encodable {
        try set.map { try self.encode($0) }
    }
}
