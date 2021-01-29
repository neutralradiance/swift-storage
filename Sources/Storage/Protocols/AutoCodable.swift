//
//  AutoCodable.swift
//
//
//  Created by neutralradiance on 10/21/20.
//

import Combine
import Foundation

/// An object that conforms to `AutoDecodable` & `AutoEncodable`.
public typealias AutoCodable = AutoDecodable & AutoEncodable

/// An object with a static, top level decoder.
public protocol AutoDecodable: Codable {
	typealias AutoDecoder = JSONDecoder
	/// Decoder used for decoding a `AutoDecodable` object.
	static var decoder: AutoDecoder { get }
}

/// An object with a static, top level encoder.
public protocol AutoEncodable: Codable {
	typealias AutoEncoder = JSONEncoder
	/// Encoder used for encoding a `AutoEncodable` object.
	static var encoder: AutoEncoder { get }
}

public extension AutoEncodable {
	func encoded() throws -> Data {
		try Self.encoder.encode(self)
	}
}
