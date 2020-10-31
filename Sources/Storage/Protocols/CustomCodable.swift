//
//  CustomCodable.swift
//  
//
//  Created by neutralradiance on 10/21/20.
//

import Foundation
import Combine

/// An object that conforms to `CustomDecodable` & `CustomEncodable`.
public typealias CustomCodable = CustomDecodable & CustomEncodable

/// An object with a static, top level decoder.
public protocol CustomDecodable: Codable {
    associatedtype Decoder: TopLevelDecoder

    /// Decoder used for decoding a `CustomDecodable` object.
    static var decoder: Decoder { get }
}

/// An object with a static, top level encoder.
public protocol CustomEncodable: Codable {
    associatedtype Encoder: TopLevelEncoder

    /// Encoder used for encoding a `CustomEncodable` object.
    static var encoder: Encoder { get }
}
