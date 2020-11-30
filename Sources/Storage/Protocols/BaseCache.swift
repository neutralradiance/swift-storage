//
//  BaseCache.swift
//  
//
//  Created by neutralradiance on 10/25/20.
//

import Foundation

public protocol BaseCache: BaseStorage {
    static var key: String { get }
    init()
}

extension BaseCache {
    public static var fileManager: FileManager { FileManager.default }
    public static func cache() throws -> URL {
        try FileManager.default.url(for: .cachesDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil, create: false)

    }
    public static func fileExists(_ url: URL) -> Bool {
        fileManager.fileExists(atPath: url.path)
    }
    @discardableResult
    public static func folder(createIfNeeded: Bool = false) throws -> URL {
        let url = try cache().appendingPathComponent(key)
        if createIfNeeded {
            guard !fileManager.fileExists(atPath: url.path) else { return url }
        try fileManager.createDirectory(
            atPath: url.path,
            withIntermediateDirectories: true,
            attributes: nil)
        }
        return url
    }
    public static func contents(createIfNeeded: Bool = true) throws -> [URL] {
        try FileManager.default
            .contentsOfDirectory(at: folder(createIfNeeded: true),
                                 includingPropertiesForKeys: nil,
                                 options: [.skipsHiddenFiles,
                                           .skipsSubdirectoryDescendants,
                                           .skipsPackageDescendants])

    }
    public static func clear() throws {
        try FileManager.default.removeItem(at: folder())
    }
    public static var shared: Self { Self() }
}
