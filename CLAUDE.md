# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ScrapingFish is a Swift Package Manager library that wraps the ScrapingFish web scraping API (`https://scraping.narf.ai/api/v1/`). It provides a type-safe, async/await interface for scraping web pages with support for JavaScript rendering, extraction rules, and JS automation scenarios.

## Build & Test Commands

```bash
swift build    # Build the library
swift test     # Run all tests
```

Single test: `swift test --filter ScrapingFishTests.TestClassName/testMethodName`

## Architecture

**Swift 6.0 / Platforms:** iOS 16+, macOS 13+
**External dependency:** Alamofire 5.10+

### Source layout (`ScrapingFish/Sources/ScrapingFish/`)

- **`ScrapingFish.swift`** — Public entry point. `ScrapingFish` struct (init with API key + timeout), `ScrapingFishParameter` enum for query parameters, and the `toQueryItems` conversion logic. Two main methods: `debug()` returns raw String, `scrape()` decodes into a generic `Decodable` type.
- **`Managers/NetworkManager.swift`** — Static Alamofire wrapper with two overloads: one returning `Decodable`, one returning raw `String`.
- **`Models/ExtractionRule.swift`** — `ExtractionRule` class and supporting types (`SelectorType`, `ExtractionOutputType`, `ExtractionType`). Supports nested extraction rules via `.nested([ExtractionRule])`.
- **`Models/JSScenario.swift`** — `JSScenario` enum representing browser automation steps (click, input, scroll, wait, evaluate JS, etc.).
- **`Extensions/`** — String formatting helpers (`inBraces`, `inBrackets`, `inQuotes`, `colon`, `comma`, `commaSeparated`) used to manually build JSON strings for API parameters.

### Key design decisions

- **Manual JSON string building:** The library constructs JSON strings via String extensions (`.inBraces`, `.inQuotes`, etc.) rather than using `JSONEncoder`. This is intentional for precise control over the API query parameter format.
- **All public types conform to `Sendable`** for thread safety with Swift concurrency.
- **`ScrapingFishParameter` enum** maps each case to its API query parameter key via `associatedValue()` (e.g., `.renderJS` → `"render_js"`).

### Tests (`ScrapingFish/Tests/`)

Tests cover extensions (String, Array, Int) and model serialization (JSScenario, ExtractionRule). Tests validate the manual JSON string output format, not network calls.

## Git Conventions

- **Never add Co-Authored-By lines** to commits.
- **Atomic commits:** Make multiple small, focused commits — each one addressing a single logical change.
- **Conventional Commits:** Follow the format `type(scope): description` (e.g., `feat(extraction): add support for nested rules`, `fix(network): handle timeout errors`, `test(jsscenario): add wait type tests`, `refactor(extensions): simplify string formatting`).
