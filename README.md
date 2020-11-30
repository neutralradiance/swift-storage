# Storage

A set of easy and simple to use persistence property wrappers for `Codable` objects . 
Storage allows you to cache objects using universally unique identifiers (UUIDs) and also encode and decode into `UserDefaults` with the use of property wrappers.  

### Stating Conformance
```swift
/// An object that will be encoded/decoded in default JSON format.
protocol JSONCodable: CustomCodable {}

extension JSONCodable {
    static var decoder: JSONDecoder { JSONDecoder() }
    static var encoder: JSONEncoder { JSONEncoder() }
}
```

### Creating `CustomCodable` objects
```swift
/// An article in a newspaper.
struct Article: JSONCodable, Cacheable {
    var id: UUID /// id for conforming to `Cacheable` aka `Identifiable` & `CustomCodable`
    var author: String
    var title: String
    var body: String
    var timestamp: Date
}

/// Conformance to `Infallible` to make it easier to unwrap values from `UserDefaults`
/// (especially useful when offline or generating random data)
extension Article: Infallible {
    static var defaultValue: Article {
        Article(id: UUID(),
                author: "John Doe",
                title: "The story about nothing.",
                body: "...", timestamp: .distantPast)
    }
}

/// A newspaper object.
/// Conforms to the `Cacheable` protocol
struct News: JSONCodable, Cacheable {
    var id: UUID
    var headline: String
    var articles: [Article]
    var timestamp: Date
}

extension News: Infallible {
    static var defaultValue: News {
        News(id: UUID(),
             headline: "Breaking News, Wow!",
             articles: [.defaultValue],
             timestamp: Article.defaultValue.timestamp
                .addingTimeInterval(999999)
        )
    }
}
```
### Initializing property wrappers 

`Codable` property wrapper for  `UserDefaults` 
```swift
@Storage("currentIssue") var news: News = .defaultValue
@Storage.Set("allIssues") var issues: [News] = [.defaultValue]
```

Property wrapper for caching `Codable` objects
```swift
/// optional typealias for a static `Cache` with the associated type `Article`
typealias ArticleCache = Cache<Article> // ready for caching

/// Dynamic property wrapper
@ArticleCache var articles: [Article] = []
```

Creating an image cache that conforms to `Codable`
```swift
struct AvatarImage: SerializedImage, CustomCodable, Identifiable {
    var id: UUID = UUID()
    var image: UIImage?
    var timestamp: Date?
    var expiration: Date?
    
    /// Custom decoder for images
    static var decoder: ImageDecoder {
        ImageDecoder()
    }
    /// Custom encoder for images with a customizable encoding strategy
    static var encoder: ImageEncoder {
        let encoder = ImageEncoder()
        encoder.encodingStrategy = .jpeg(0)
        return encoder
    }
}
```

Then use it with any of the above property wrappers:

Statically,
```swift
typealias AvatarCache = Cache<AvatarImage>

AvatarCache[id] = AvatarImage(id: id, image: image) // to set image with a `UUID`
AvatarCache[id] = nil // to remove image with corresponding `id`
```
or dynamically,
```swift
@AvatarCache var avatarCache: [AvatarImage] = []

avatarCache.append(AvatarImage(id: id, image: image)) // to append an image to the cache
avatarCache.remove(at: 0) // to remove an image at the first index
avatarCache = [] // to remove all
```
