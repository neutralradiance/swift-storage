//
//  SerializedCache.swift
//  
//
//  Created by neutralradiance on 10/28/20.
//

import Foundation

/// An object that conforms to `Identifiable` & `CustomCodable`.
public typealias Cacheable = Identifiable & CustomCodable

public protocol SerializedCache: BaseCache where Value: Cacheable, Value.ID == UUID,
                                                 Value.Decoder.Input == Data, Value.Encoder.Output == Data {
    static subscript (id: Value.ID) -> Value? { get set }
}

extension SerializedCache {
    /// An automatically determined location for `Value` to be stored based on `UUID`.
    public static func fileURL(_ id: Value.ID) throws -> URL {
        try folder().appendingPathComponent(id.uuidString)
    }
    public func exists(_ id: Value.ID) throws -> Bool {
        try Self.fileExists(Self.fileURL(id))
    }
    public static func dataContents() throws -> [Data] {
        try contents().map { try getData($0) }
    }
    public static func getData(_ url: URL) throws -> Data {
        try Data(contentsOf: url, options: .uncachedRead)
    }
    public static func objects() throws -> [Value] {
        try Value.decoder.decode(Value.self, fromArray: Self.dataContents())
    }
    public static func add(_ contents: [Value]) throws {
        let dir = try folder(createIfNeeded: true)
        try contents.forEach { value in
            let url = dir.appendingPathComponent(value.id.uuidString)
            if !fileExists(url) {
                let data = try Value.encoder.encode(value)
                try data.write(to: url)
            }
        }
    }
    public static func subtract(_ contents: [Value]) throws {
        var directory = try Self.contents()
        // remove values needed to cache
        contents.forEach { value in
            // check if already cached
            if let commonIndex = directory.firstIndex(where: { $0.lastPathComponent == value.id.uuidString }) {
                directory.remove(at: commonIndex)
            } else {
                // cache the new value if not
                Self[value.id] = value
            }
        }
        // delete the values needed to remove
        try directory.forEach { url in
            try fileManager.removeItem(at: url)
        }
    }
}
