//
//  TimSortTests.swift
//  AdditionalSortsTests
//
//  Created by Valeriano Della Longa on 2021/03/23.
//  Copyright © 2021 Valeriano Della Longa
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

import XCTest
@testable import AdditionalSorts

final class TimSortTests: XCTestCase {
    func testTimSort_whenIsEmpty_thenNothingChanges() {
        var sut = [Int]()
        sut.timSort(by: <)
        XCTAssertTrue(sut.isEmpty)
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll<Int>(elements: [])
        coll.timSort(by: <)
        XCTAssertTrue(coll.isEmpty)
    }
    
    func testTimSort_whenIsNotEmpty_thenSortsInPlace() {
        var sut = shuffledElements
        sut.timSort(by: <)
        XCTAssertTrue(sut.elementsEqual(sortedElements), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: shuffledElements)
        coll.timSort(by: <)
        XCTAssertTrue(coll.elementsEqual(sortedElements), "not sorted")
    }
    
    func testTimSort_whenIsNotEmptyAndAlreadySorted_thenStaysSorted() {
        let sorted = Array(sortedElements)
        var sut = sorted
        
        sut.timSort(by: <)
        XCTAssertTrue(sut.elementsEqual(sortedElements), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: sorted)
        coll.timSort(by: <)
        XCTAssertTrue(coll.elementsEqual(sortedElements), "not sorted")
    }
    
    func testTimSort_whenPredicateThrows_thenRethrows() {
        var sut = shuffledElements
        do {
            try sut.timSort(by: alwaysThrowingPredicate)
        } catch {
            XCTAssertEqual(error as NSError, err)
            return
        }
        XCTFail("has not rethrown error")
    }
    
}
