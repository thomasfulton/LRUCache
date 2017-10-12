//
//  LRUCacheTest.swift
//  LRUCacheTest
//
//  Created by Thomas Fulton on 2017-10-11.
//

import XCTest
@testable import LRUCache

class LRUCacheTest: XCTestCase {
    func testCacheSize0() {
        let cache = LRUCache<String>(maxSize: 0)
        cache.set("arst", forKey: "0")
        XCTAssertNil(cache.get(forKey: "0"))
        XCTAssertNil(cache.get(forKey: "1"))
    }

    func testCacheSize1() {
        let cache = LRUCache<String>(maxSize: 1)

        cache.set("arst", forKey: "0")
        XCTAssertEqual(cache.get(forKey: "0"), "arst")
        XCTAssertNotEqual(cache.get(forKey: "0"), "neio")
        XCTAssertNil(cache.get(forKey: "1"))

        cache.set("neio", forKey: "0")
        XCTAssertNotEqual(cache.get(forKey: "0"), "arst")
        XCTAssertEqual(cache.get(forKey: "0"), "neio")
        XCTAssertNil(cache.get(forKey: "1"))

        cache.set("qwfp", forKey: "1")
        XCTAssertNil(cache.get(forKey: "0"))
        XCTAssertNotEqual(cache.get(forKey: "1"), "neio")
        XCTAssertEqual(cache.get(forKey: "1"), "qwfp")

        cache.set("arst", forKey: "0")
        XCTAssertEqual(cache.get(forKey: "0"), "arst")
        XCTAssertNotEqual(cache.get(forKey: "0"), "neio")
        XCTAssertNil(cache.get(forKey: "1"))
    }

    func testCacheSize2() {
        let cache = LRUCache<String>(maxSize: 2)
        cache.set("arst", forKey: "0")
        XCTAssertEqual(cache.get(forKey: "0"), "arst")
        XCTAssertNil(cache.get(forKey: "1"))

        cache.set("neio", forKey: "0")
        XCTAssertNotEqual(cache.get(forKey: "0"), "arst")
        XCTAssertNil(cache.get(forKey: "1"))

        cache.set("qwfp", forKey: "1")
        XCTAssertEqual(cache.get(forKey: "0"), "neio")
        XCTAssertEqual(cache.get(forKey: "1"), "qwfp")

        cache.set("arst", forKey: "2")
        XCTAssertNil(cache.get(forKey: "0"))
        XCTAssertEqual(cache.get(forKey: "2"), "arst")
        XCTAssertEqual(cache.get(forKey: "1"), "qwfp")

        cache.set("arst", forKey: "3")
        XCTAssertNil(cache.get(forKey: "0"))
        XCTAssertEqual(cache.get(forKey: "1"), "qwfp")
        XCTAssertNil(cache.get(forKey: "2"))
        XCTAssertEqual(cache.get(forKey: "3"), "arst")
    }

    func testCacheSize3() {
        let cache = LRUCache<String>(maxSize: 3)
        cache.set("arst", forKey: "0")
        cache.set("neio", forKey: "1")
        cache.set("qwfp", forKey: "2")
        cache.set("1234", forKey: "3")
        XCTAssertNil(cache.get(forKey: "0"))
        XCTAssertEqual(cache.get(forKey: "1"), "neio")
        XCTAssertEqual(cache.get(forKey: "2"), "qwfp")
        XCTAssertEqual(cache.get(forKey: "3"), "1234")
        XCTAssertEqual(cache.count, 3)

    }

    func testCacheOverwrites() {
        let cache = LRUCache<String>(maxSize: 3)
        cache.set("arst", forKey: "0")
        cache.set("neio", forKey: "0")
        XCTAssertEqual(cache.count, 1)
        XCTAssertEqual(cache.get(forKey: "0"), "neio")
    }

    func testSetMarksNew() {
        let cache = LRUCache<String>(maxSize: 3)
        cache.set("arst", forKey: "0")
        cache.set("neio", forKey: "1")
        cache.set("qwfp", forKey: "2")
        cache.set("arst", forKey: "0")
        cache.set("qwfp", forKey: "2")
        cache.set("1234", forKey: "3")
        XCTAssertEqual(cache.get(forKey: "0"), "arst")
        XCTAssertNil(cache.get(forKey: "1"))
        XCTAssertEqual(cache.get(forKey: "2"), "qwfp")
        XCTAssertEqual(cache.get(forKey: "3"), "1234")
        XCTAssertEqual(cache.count, 3)
    }

    func testGetMarksNew() {
        let cache = LRUCache<String>(maxSize: 3)
        cache.set("arst", forKey: "0")
        cache.set("neio", forKey: "1")
        cache.set("qwfp", forKey: "2")
        cache.get(forKey: "0")
        cache.get(forKey: "2")
        cache.set("1234", forKey: "3")
        XCTAssertEqual(cache.get(forKey: "0"), "arst")
        XCTAssertNil(cache.get(forKey: "1"))
        XCTAssertEqual(cache.get(forKey: "2"), "qwfp")
        XCTAssertEqual(cache.get(forKey: "3"), "1234")
        XCTAssertEqual(cache.count, 3)
    }
}
