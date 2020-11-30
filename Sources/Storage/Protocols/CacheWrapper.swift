//
//  CacheWrapper.swift
//  
//
//  Created by neutralradiance on 10/25/20.
//

import SwiftUI

/// A property wrapper for dynamically caching objects.
public protocol CacheWrapper: StorageWrapper, BaseCache {}

extension CacheWrapper {
    public func clear() throws {
        try Self.clear()
    }
}
