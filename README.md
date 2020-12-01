# Storage
A set of easy and simple to use persistence property wrappers for for `Codable` objects .  
Storage allows you to cache objects using universally unique identifiers (UUIDs) and also encode and decode into `UserDefaults` with the use of property wrappers.  
Now supports `CloudKit`/`CoreData` storage.

## CloudKit Storage
### Creating Keys for `Cloud` property wrappers
```swift
/// A key for accessing a `CloudEntity`.
extension CloudKey {
    static var items: Self<Item> { .init() }
}

/// The location for cloud key lookup.
/// It must be an extension of `CloudContainer`
extension CloudContainer {
    var items: Set<Item> {
        get { self[.items] }
        set { self[.items] = newValue }
    }
}
```
- **All objects that use `Cloud`  property wrapper must conform to `CloudEntity`**
- **Have a `CoreData` model name specified in the `CloudContainer`.
Defaults to "BaseModel" with the static property `CloudContainer.base`**
- **and have a `CoreData` model with name matching a matching `CloudContainer.name` property**

```swift
static let model = CloudContainer(named: "ItemModel")
```
### Using keys to access `Cloud` property wrappers
```swift
// default
@Published var cloud: CloudContainer = .base
lazy var context = cloud.container.viewContext
@Cloud(\.items) var items: Set<Item>

// or custom model
@Published var cloud: CloudContainer = model
lazy var context = cloud.container.viewContext
@Cloud(\.items, container: cloud) var items: Set<Item>
```

## Local Storage
### Stating Conformance To AutoCodable
```swift
/// An object that will be encoded/decoded in default JSON format.
protocol JSONCodable: AutoCodable {}

extension JSONCodable {
    static var decoder: JSONDecoder { JSONDecoder() }
    static var encoder: JSONEncoder { JSONEncoder() }
}
```
### Creating AutoCodable objects
```swift
/// An article in a newspaper.
struct Article: JSONCodable, Cacheable {
    var id: UUID /// id for conforming to `Cacheable` aka `Identifiable` & `AutoCodable`
    var author: String
    var title: String
    var body: String
    var timestamp: Date
}

/// Conformance to `Infallible` to make it easier to unwrap values from `UserDefaults`
/// (especially useful when  for offline testing.)
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
@Store("currentIssue") var news: News = .defaultValue
@Store.Set("allIssues") var issues: [News] = [.defaultValue]
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
struct AvatarImage: SerializedImage, AutoCodable, Identifiable {
    var id: UUID = UUID()
    var image: UIImage?
    var timestamp: Date?
    var expiration: Date?
    
    /// Auto decoder for images
    static var decoder: ImageDecoder {
        ImageDecoder()
    }
    /// Auto encoder for images with a Autoizable encoding strategy
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
