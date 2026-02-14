import Testing
@testable import ScrapingFish

@Suite("JSScenarioBuilder")
struct JSScenarioBuilderTests {
    @Test("Builds scenario with multiple steps")
    func multipleSteps() {
        let scenario = JSScenario {
            JSStep.waitFor(selector: "#content", timeout: 5000)
            JSStep.click(selector: "#load-more")
            JSStep.wait(.milliseconds(2000))
        }
        #expect(scenario.steps.count == 3)
    }

    @Test("Builds scenario with conditional steps")
    func conditionalSteps() {
        let needsScroll = true
        let scenario = JSScenario {
            JSStep.click(selector: "#btn")
            if needsScroll {
                JSStep.scroll()
            }
            JSStep.wait(.milliseconds(500))
        }
        #expect(scenario.steps.count == 3)
    }

    @Test("Builds scenario with false conditional")
    func falseConditional() {
        let needsScroll = false
        let scenario = JSScenario {
            JSStep.click(selector: "#btn")
            if needsScroll {
                JSStep.scroll()
            }
            JSStep.wait(.milliseconds(500))
        }
        #expect(scenario.steps.count == 2)
    }

    @Test("Produces correct JSON from builder")
    func producesCorrectJSON() {
        let scenario = JSScenario {
            JSStep.click(selector: "#btn")
            JSStep.wait(.milliseconds(1000))
        }
        let json = scenario.encodeToJSON()
        let expected = "{\"steps\":[{\"click\":\"#btn\"},{\"wait\":1000}]}"
        #expect(json == expected)
    }
}
