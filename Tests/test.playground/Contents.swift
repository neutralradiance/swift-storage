import Storage
import Unwrap
import XCPlayground
import XCTest

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
		     timestamp: Article.defaultValue.timestamp.addingTimeInterval(999_999))
	}
}

final class StorageTests: XCTestCase {
	@Storage("currentIssue") var news: News = .defaultValue
	func storageTest() {
		// encode
		news.headline = "WoW"
		news.articles.append(contentsOf: [.defaultValue, .defaultValue])
		// decode
		print(_news.wrappedValue.headline, _news.wrappedValue.articles.count)
		_news.clear()
	}

	@Storage.Set("allIssues") var issues: [News] = [.defaultValue]
	func setStorageTest() {
		issues.append(contentsOf: [.defaultValue, .defaultValue, .defaultValue])
		issues[0].articles.remove(at: 0)
		issues[0].headline = "Something Interesting"
		issues.remove(at: 3)
		print(issues.count, issues.first!.articles.count, issues.first!.headline, issues.count)
		_issues.clear()
	}

	typealias ArticleCache = Cache<Article> // ready for caching
	@ArticleCache var articles: [Article] = []

	func cacheTests() {
		if try! ArticleCache.fileExists(ArticleCache.folder()) {
			print("Clearing cache")
			try? ArticleCache.clear()
		}
		let values: [Article] = [.defaultValue,
		                         .defaultValue,
		                         .defaultValue]

		articles.append(contentsOf: values)
		// try to cache two articles
		var first: Article = .defaultValue
		first.title = "First"

		var second: Article = .defaultValue
		second.title = "Second"

		// should cache each one in both cases

		ArticleCache[first.id] = first

		articles.append(second)

		// counting the articles saved, 3+2 = 5
		guard articles.count == 5 else {
			return
		}

		// see if the cached objects exist on the filesystem through uuid
		do {
			// count the items created in the folder
			guard try ArticleCache.contents().count == 5 else { return }

			//            // check the cached objects
			guard let cachedFirst = ArticleCache[first.id],
			      first.title == cachedFirst.title
			else {
				return
			}

			guard let cachedSecond = ArticleCache[second.id],
			      second.title == cachedSecond.title
			else {
				return
			}

			// remove the objects
			if let firstIndex =
				articles.firstIndex(where: { $0.id == cachedFirst.id })
			{
				articles.remove(at: firstIndex)
			}

			ArticleCache[cachedSecond.id] = nil

			// check to see if they're missing
			guard ArticleCache[first.id] == nil,
			      ArticleCache[second.id] == nil,
			      articles.firstIndex(where: { $0.id == cachedFirst.id }) == nil,
			      articles.firstIndex(where: { $0.id == cachedSecond.id }) == nil else { return }
			guard articles.count == 3 else { return }
		} catch {
			print(error.localizedDescription)
		}
		try? _articles.clear()
		print("finished cache test")
	}

	static var allTests: [(String, (StorageTests) -> () -> Void)] = [
		("storageTest", storageTest),
		("setStorageTest", setStorageTest),
		("cacheTests", cacheTests),
	]
}

let instance = StorageTests()

StorageTests.allTests.forEach { name, test in
	debugPrint("running \(name)...")
	test(instance)()
}
