import XCTest
@testable import Storage
@testable import Unwrap

/// An object that will be encoded/decoded in default JSON format.
protocol JSONCodable: CustomCodable {}

extension JSONCodable {
    static var decoder: JSONDecoder { JSONDecoder() }
    static var encoder: JSONEncoder { JSONEncoder() }
}

/// An article in a newspaper.
struct Article: JSONCodable, Cacheable {
    var id: UUID /// id for conforming to `Cacheable` aka `Identifiable` & `CustomCodable`
    var author: String
    var title: String
    var body: String
    var timestamp: Date
}

/// Conformance to `Infallible` to make it easier to unwrap values from `UserDefaults`
/// (especially useful when loading offline or random data for testing.)
extension Article: Infallible {
    static var defaultValue: Article {
        Article(id: UUID(),
                author: "John Doe",
                title: "The story about nothing.",
                body: "...", timestamp: .distantPast)
    }
}

/// A newspaper object.
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
             timestamp: Article.defaultValue.timestamp.addingTimeInterval(999999))
    }
}

final class StorageTests: XCTestCase {
    @Storage("currentIssue") var news: News = .defaultValue
    func storageTest() {

        _news.clear()
    }

//    @Storage.Set("allIssues") var issues: [News] = [.defaultValue]
//    func setStorageTest() {
//
//        _issues.clear()
//    }

    typealias ArticleCache = Cache<Article> // ready for caching
    @ArticleCache var articles: [Article] = [.defaultValue,
                                             .defaultValue,
                                             .defaultValue]
    func cacheTests() {
        debugPrint("Testing Cache...")
        // try to cache two articles
        var first: Article = .defaultValue
        first.title = "First"

        var second: Article = .defaultValue
        second.title = "Second"

        // should cache each one in both cases
        ArticleCache[first.id] = first
        articles.append(second)

        // counting the articles saved, 3+2 = 5
        XCTAssertEqual(articles.count, 5)

        // see if the cached objects exist on the filesystem through uuid
        do {
            // unwrap the cache folder
            let cache = try XCTUnwrap(ArticleCache.folder())

            // count the items created in the folder
            XCTAssertEqual(
                try ArticleCache.fileManager.contentsOfDirectory(at: cache,
                                                                 includingPropertiesForKeys: nil,
                                                                 options: [.skipsSubdirectoryDescendants,
                                                                           .skipsHiddenFiles]).count, 5)

            // unwrap the cached objects
            let cachedFirst = try XCTUnwrap(ArticleCache[first.id])
            XCTAssertEqual(first.title, cachedFirst.title)

            let cachedSecond = try XCTUnwrap(ArticleCache[second.id])
            XCTAssertEqual(second.title, cachedSecond.title)

            // remove the objects
            let firstIndex = try XCTUnwrap(articles.firstIndex(where: { $0.id == cachedFirst.id }))
            articles.remove(at: firstIndex)
            ArticleCache[cachedSecond.id] = nil

            // check to see if they're missing
            XCTAssertNil(ArticleCache[first.id])
            XCTAssertNil(ArticleCache[second.id])

            XCTAssertNil(articles.firstIndex(where: { $0.id == cachedFirst.id }))
            XCTAssertNil(articles.firstIndex(where: { $0.id == cachedSecond.id }))
            XCTAssertEqual(articles.count, 3)
        } catch {
            XCTFail(error.localizedDescription)
        }
        try XCTAssertNoThrow(_articles.clear())
    }

    static var allTests: [(String, ((StorageTests) -> () -> Void))] = [
        ("storageTest", storageTest),
        //("setStorageTest", setStorageTest),
        ("cacheTests", cacheTests)
    ]
}
