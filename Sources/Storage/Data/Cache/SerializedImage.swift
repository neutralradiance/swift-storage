//
//  SerializedImage.swift
//
//
//  Created by neutralradiance on 10/29/20.
//

#if os(iOS)
  import UIKit

  /// A class for cached images that can be used with `Cache` after
  ///  conforming to `Cacheable`.
  open class SerializedImage: NSObject, AutoCodable {
    public var id = UUID()
    public var image: UIImage? = .none
    public var timestamp: Date? = .none
    public var expiration: Date? = .none
    public required init(from decoder: Decoder) throws {
      let container =
        try decoder.container(keyedBy: SerializedImageKey.self)
      let data =
        try container.decode(Data.self, forKey: .image)
      guard
        let image = UIImage(data: data)
      else {
        throw DecodingError.dataCorrupted(
          .init(
            codingPath: container.codingPath,
            debugDescription: "Data couldn't be read for image."
          )
        )
      }

      id = try container.decode(UUID.self, forKey: .id)
      self.image = image

      if let timestamp =
        try container.decodeIfPresent(
          TimeInterval.self,
          forKey: .timestamp
        ) {
        self.timestamp =
          Date(timeIntervalSinceReferenceDate: timestamp)
      }
      if let expiration =
        try container.decodeIfPresent(
          TimeInterval.self,
          forKey: .expiration
        ) {
        self.expiration =
          Date(timeIntervalSinceReferenceDate: expiration)
      }
    }

    public func encode(to _: Encoder) throws {}
    public static let encoder = ImageEncoder()
    public static let decoder = ImageDecoder()
    override open var classForCoder: AnyClass {
      Self.AutoDecoder
    }
  }

  public extension SerializedImage {
    convenience init(
      id: UUID = UUID(),
      image: UIImage = UIImage(),
      timestamp: Date? = nil,
      expiration: Date? = nil
    ) throws {
      try self.init()
      self.id = id
      self.image = image
      self.timestamp = timestamp
      self.expiration = expiration
    }
  }

  /// Coding key for encoding / decoding a `SerializedImage`
  enum SerializedImageKey: CodingKey {
    case id, image, timestamp, expiration
  }
#endif
