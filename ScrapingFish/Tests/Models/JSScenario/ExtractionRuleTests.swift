import XCTest
import ScrapingFish

final class ExtractionRuleTests: XCTestCase {
    func testExtractionRuleOfTextType() throws {
        let sut: ExtractionRules = [
            ExtractionRule(name: "items", type: .all, selectors: [
            SelectorType(".item")
        ], output: .nested([ExtractionRule(selectors: [
            SelectorType(name: "price", ".price"),
            SelectorType(name: "date", ".date"),
        ], output: .nested([ExtractionRule(name: "details", selectors: [
            SelectorType(".details")
        ], output: .nested([ExtractionRule(selectors: [
            SelectorType(name: "title", ".title"),
            SelectorType(name: "description", ".description")
        ])]
        ))]
        ))]
        ))]
        let expected: String = "\"items\":{\"type\":\"all\",\"selector\":\".item\",\"output\":{\"price\":\".price\",\"date\":\".date\",\"details\":{\"selector\":\".details\",\"output\":{\"title\":\".title\",\"description\":\".description\"}}}}"
        XCTAssertEqual(sut.toString, expected)
    }
    
    func testExtractionRule() throws {
        let sut: ExtractionRules = [
            ExtractionRule(name: "perfumes", type: .all, selectors: [
                SelectorType("div.cell.card.fr-news-box")
            ], output: .nested([
                ExtractionRule(output: .nested([
                    ExtractionRule(name: "image", selectors: [
                        SelectorType("div.card-section img")
                    ], output: .attribute("src")),
                    ExtractionRule(name: "name", selectors: [
                        SelectorType("div.card-section a")
                    ], output: .text),
                    ExtractionRule(name: "url", selectors: [
                        SelectorType("div.card-section a")
                    ], output: .href),
                    ExtractionRule(name: "brand", selectors: [
                        SelectorType("div.card-section small")
                    ], output: .text)]))
            ]))
        ]
        let expected: String = "\"perfumes\":{\"type\":\"all\",\"selector\":\"div.cell.card.fr-news-box\",\"output\":{\"image\":{\"selector\":\"div.card-section img\",\"output\":\"@src\"},\"name\":{\"selector\":\"div.card-section a\",\"output\":\"text\"},\"url\":{\"selector\":\"div.card-section a\",\"output\":\"@href\"},\"brand\":{\"selector\":\"div.card-section small\",\"output\":\"text\"}}}"
        XCTAssertEqual(sut.toString, expected)
    }
}
