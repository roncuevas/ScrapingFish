import Testing
@testable import ScrapingFish

@Suite("JSScenario Encoding")
struct JSScenarioTests {
    @Test("Encodes simple wait with milliseconds")
    func waitMilliseconds() {
        let scenario = JSScenario(steps: [.wait(.milliseconds(2000))])
        let json = scenario.encodeToJSON()
        let expected = "{\"steps\":[{\"wait\":2000}]}"
        #expect(json == expected)
    }

    @Test("Encodes randomized wait")
    func waitRandomized() {
        let scenario = JSScenario(steps: [.wait(.randomized(min: 1000, max: 3000))])
        let json = scenario.encodeToJSON()
        let expected = "{\"steps\":[{\"wait\":{\"random\":{\"min_ms\":1000,\"max_ms\":3000}}}]}"
        #expect(json == expected)
    }

    @Test("Encodes click step")
    func click() {
        let scenario = JSScenario(steps: [.click(selector: "#btn")])
        let json = scenario.encodeToJSON()
        let expected = "{\"steps\":[{\"click\":\"#btn\"}]}"
        #expect(json == expected)
    }

    @Test("Encodes clickIfExists step")
    func clickIfExists() {
        let scenario = JSScenario(steps: [.clickIfExists(selector: ".popup-close")])
        let json = scenario.encodeToJSON()
        let expected = "{\"steps\":[{\"click_if_exists\":\".popup-close\"}]}"
        #expect(json == expected)
    }

    @Test("Encodes clickAndWaitForNavigation step")
    func clickAndWaitForNavigation() {
        let scenario = JSScenario(steps: [.clickAndWaitForNavigation(selector: "a.next")])
        let json = scenario.encodeToJSON()
        let expected = "{\"steps\":[{\"click_and_wait_for_navigation\":\"a.next\"}]}"
        #expect(json == expected)
    }

    @Test("Encodes input step")
    func input() {
        let scenario = JSScenario(steps: [.input(selector: "#search", value: "hello")])
        let json = scenario.encodeToJSON()
        let expected = "{\"steps\":[{\"input\":\"#search\",\"value\":\"hello\"}]}"
        #expect(json == expected)
    }

    @Test("Encodes select step")
    func selectStep() {
        let scenario = JSScenario(steps: [.select(selector: "#dropdown", value: "opt1")])
        let json = scenario.encodeToJSON()
        let expected = "{\"steps\":[{\"select\":\"#dropdown\",\"value\":\"opt1\"}]}"
        #expect(json == expected)
    }

    @Test("Encodes setLocalStorage step")
    func setLocalStorage() {
        let scenario = JSScenario(steps: [.setLocalStorage(key: "token", value: "abc")])
        let json = scenario.encodeToJSON()
        let expected = "{\"steps\":[{\"set_local_storage\":{\"token\":\"abc\"}}]}"
        #expect(json == expected)
    }

    @Test("Encodes scroll step without selector")
    func scrollNoSelector() {
        let scenario = JSScenario(steps: [.scroll()])
        let json = scenario.encodeToJSON()
        let expected = "{\"steps\":[{\"scroll\":true}]}"
        #expect(json == expected)
    }

    @Test("Encodes scroll step with selector")
    func scrollWithSelector() {
        let scenario = JSScenario(steps: [.scroll(selector: "#content")])
        let json = scenario.encodeToJSON()
        let expected = "{\"steps\":[{\"scroll\":\"#content\"}]}"
        #expect(json == expected)
    }

    @Test("Encodes waitFor step without timeout")
    func waitFor() {
        let scenario = JSScenario(steps: [.waitFor(selector: "#loaded")])
        let json = scenario.encodeToJSON()
        let expected = "{\"steps\":[{\"wait_for\":\"#loaded\"}]}"
        #expect(json == expected)
    }

    @Test("Encodes waitFor step with timeout")
    func waitForWithTimeout() {
        let scenario = JSScenario(steps: [.waitFor(selector: "#loaded", timeout: 5000)])
        let json = scenario.encodeToJSON()
        let expected = "{\"steps\":[{\"wait_for\":\"#loaded\",\"timeout_ms\":5000}]}"
        #expect(json == expected)
    }

    @Test("Encodes waitForAny step with string selectors")
    func waitForAnyStrings() {
        let scenario = JSScenario(steps: [.waitForAny(["#a", "#b"])])
        let json = scenario.encodeToJSON()
        let expected = "{\"steps\":[{\"wait_for_any\":[\"#a\",\"#b\"]}]}"
        #expect(json == expected)
    }

    @Test("Encodes waitForAny step with state targets")
    func waitForAnyWithState() {
        let targets = [
            WaitForAnyTarget(selector: "#a", state: .visible),
            WaitForAnyTarget(selector: "#b", state: .attached),
        ]
        let scenario = JSScenario(steps: [.waitForAnyWithState(targets)])
        let json = scenario.encodeToJSON()
        let expected = "{\"steps\":[{\"wait_for_any\":[{\"selector\":\"#a\",\"state\":\"visible\"},{\"selector\":\"#b\",\"state\":\"attached\"}]}]}"
        #expect(json == expected)
    }

    @Test("Encodes evaluate step")
    func evaluate() {
        let scenario = JSScenario(steps: [.evaluate("document.title")])
        let json = scenario.encodeToJSON()
        let expected = "{\"steps\":[{\"evaluate\":\"document.title\"}]}"
        #expect(json == expected)
    }

    @Test("Encodes multiple steps")
    func multipleSteps() {
        let scenario = JSScenario(steps: [
            .waitFor(selector: "#content"),
            .click(selector: "#btn"),
            .wait(.milliseconds(1000)),
        ])
        let json = scenario.encodeToJSON()
        let expected = "{\"steps\":[{\"wait_for\":\"#content\"},{\"click\":\"#btn\"},{\"wait\":1000}]}"
        #expect(json == expected)
    }

    @Test("Escapes special characters in strings")
    func escapesSpecialChars() {
        let scenario = JSScenario(steps: [.evaluate("alert(\"hello\")")])
        let json = scenario.encodeToJSON()
        let expected = "{\"steps\":[{\"evaluate\":\"alert(\\\"hello\\\")\"}]}"
        #expect(json == expected)
    }
}
