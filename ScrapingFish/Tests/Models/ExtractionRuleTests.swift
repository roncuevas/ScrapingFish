import Testing
import Foundation
@testable import ScrapingFish

@Suite("ExtractionRule Encoding")
struct ExtractionRuleTests {
    @Test("Encodes simple text extraction rule")
    func simpleTextRule() throws {
        let rules = ExtractionRules([
            "title": ExtractionRule(selector: "h1", output: .text)
        ])
        let json = rules.encodeToJSON()
        let parsed = try JSONSerialization.jsonObject(with: Data(json.utf8)) as! [String: Any]
        let title = parsed["title"] as! [String: Any]
        #expect(title["selector"] as? String == "h1")
        #expect(title["output"] as? String == "text")
    }

    @Test("Encodes rule with type=all")
    func allTypeRule() throws {
        let rules = ExtractionRules([
            "items": ExtractionRule(selector: ".item", type: .all, output: .text)
        ])
        let json = rules.encodeToJSON()
        let parsed = try JSONSerialization.jsonObject(with: Data(json.utf8)) as! [String: Any]
        let items = parsed["items"] as! [String: Any]
        #expect(items["selector"] as? String == ".item")
        #expect(items["type"] as? String == "all")
        #expect(items["output"] as? String == "text")
    }

    @Test("Omits type when first (default)")
    func omitsDefaultType() throws {
        let rules = ExtractionRules([
            "title": ExtractionRule(selector: "h1", type: .first, output: .text)
        ])
        let json = rules.encodeToJSON()
        let parsed = try JSONSerialization.jsonObject(with: Data(json.utf8)) as! [String: Any]
        let title = parsed["title"] as! [String: Any]
        #expect(title["type"] == nil)
    }

    @Test("Encodes attribute extraction")
    func attributeRule() throws {
        let rules = ExtractionRules([
            "image": ExtractionRule(selector: "img", attribute: "src")
        ])
        let json = rules.encodeToJSON()
        let parsed = try JSONSerialization.jsonObject(with: Data(json.utf8)) as! [String: Any]
        let image = parsed["image"] as! [String: Any]
        #expect(image["output"] as? String == "@src")
    }

    @Test("Encodes html output")
    func htmlOutput() throws {
        let rules = ExtractionRules([
            "content": ExtractionRule(selector: ".body", output: .html)
        ])
        let json = rules.encodeToJSON()
        let parsed = try JSONSerialization.jsonObject(with: Data(json.utf8)) as! [String: Any]
        let content = parsed["content"] as! [String: Any]
        #expect(content["output"] as? String == "html")
    }

    @Test("Encodes nested extraction rules")
    func nestedRules() throws {
        let inner = ExtractionRules([
            "name": ExtractionRule(selector: ".name", output: .text),
            "price": ExtractionRule(selector: ".price", output: .text),
        ])
        let rules = ExtractionRules([
            "products": ExtractionRule(selector: ".product", type: .all, nested: inner)
        ])
        let json = rules.encodeToJSON()
        let parsed = try JSONSerialization.jsonObject(with: Data(json.utf8)) as! [String: Any]
        let products = parsed["products"] as! [String: Any]
        #expect(products["selector"] as? String == ".product")
        #expect(products["type"] as? String == "all")
        let output = products["output"] as! [String: Any]
        let name = output["name"] as! [String: Any]
        #expect(name["selector"] as? String == ".name")
    }

    @Test("Encodes multiple rules")
    func multipleRules() throws {
        let rules = ExtractionRules([
            "title": ExtractionRule(selector: "h1", output: .text),
            "link": ExtractionRule(selector: "a", attribute: "href"),
        ])
        let json = rules.encodeToJSON()
        let parsed = try JSONSerialization.jsonObject(with: Data(json.utf8)) as! [String: Any]
        #expect(parsed.keys.count == 2)
        #expect(parsed["title"] != nil)
        #expect(parsed["link"] != nil)
    }

    @Test("Encodes table_json output")
    func tableJsonOutput() throws {
        let rules = ExtractionRules([
            "data": ExtractionRule(selector: "table", output: .tableJSON)
        ])
        let json = rules.encodeToJSON()
        let parsed = try JSONSerialization.jsonObject(with: Data(json.utf8)) as! [String: Any]
        let data = parsed["data"] as! [String: Any]
        #expect(data["output"] as? String == "table_json")
    }
}
