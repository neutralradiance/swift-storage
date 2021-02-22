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
  public protocol SerializedImage {
    var id: String { get set }
    var image: UIImage? { get set }
    var timestamp: Date? { get set }
    var expiration: Date? { get set }
    init()
  }
extension SerializedImage {
    public init(from decoder: Decoder) throws {
      self.init()
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

      self.id = try container.decode(String.self, forKey: .id)
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
  public static var encoder: ImageEncoder { ImageEncoder.shared }
  public static var decoder: ImageDecoder { ImageDecoder.shared }
    public init(
      id: String = UUID().uuidString,
      image: UIImage? = .none,
      timestamp: Date? = nil,
      expiration: Date? = nil
    ) {
      self.init()
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
