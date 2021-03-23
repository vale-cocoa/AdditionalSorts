//
//  QuickSortsTests.swift
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

final class QuickSortsTests: XCTestCase {
    // MARK: - dutchFlagQuickSort(by:)
    func testDutchFlagQuickSort_whenIsEmpty_thenNothigChanges() {
        var sut = [Int]()
        sut.dutchFlagQuickSort(by: <)
        XCTAssertTrue(sut.isEmpty)
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll<Int>(elements: [])
        coll.dutchFlagQuickSort(by: <)
        XCTAssertTrue(coll.isEmpty)
    }
    
    func testDutchFlagQuickSort_whenIsNotEmpty_thenSortsInPlace() {
        var sut = shuffledElements
        sut.dutchFlagQuickSort(by: <)
        XCTAssertTrue(sut.elementsEqual(sortedElements), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: shuffledElements)
        coll.dutchFlagQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(sortedElements), "not sorted")
    }
    
    func testDutchFlagQuickSort_whenIsNotEmptyAndAlreadySorted_thenStaysSorted() {
        let sorted = Array(sortedElements)
        var sut = sorted
        sut.dutchFlagQuickSort(by: <)
        XCTAssertTrue(sut.elementsEqual(sortedElements), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: sorted)
        coll.dutchFlagQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(sortedElements), "not sorted")
    }
    
    func testDutchFlagQuickSort_whenPredicateThrows_thenRethrows() {
        var sut = shuffledElements
        do {
            try sut.dutchFlagQuickSort(by: alwaysThrowingPredicate)
        } catch {
            XCTAssertEqual(error as NSError, err)
            return
        }
        XCTFail("has not rethrown error")
    }
    
    func testDutchFlagQuickSort_whenIsNotEmptyAndCountIsLessThanOrEqualtTo10_thenSortsInPlace() {
        var elements = shuffledElements
        let c = Int.random(in: 1...10)
        let k = elements.count - c
        elements.removeLast(k)
        let expectedResult = elements.sorted()
        
        elements.dutchFlagQuickSort(by: <)
        XCTAssertTrue(elements.elementsEqual(expectedResult), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: elements)
        coll.dutchFlagQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(expectedResult), "not sorted")
    }
    
    func testDutchFlagQuickSort_whenCountIsBetween11And25_thenSortsInPlace() {
        var elements = shuffledElements
        let c = Int.random(in: 11...25)
        let k = elements.count - c
        elements.removeLast(k)
        let expectedResult = elements.sorted()
        
        elements.dutchFlagQuickSort(by: <)
        XCTAssertTrue(elements.elementsEqual(expectedResult), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: elements)
        coll.dutchFlagQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(expectedResult), "not sorted")
    }
    
    func testDutchFlagQuickSort_whenCountIsBetween26And50_thenSortsInPlace() {
        var elements = shuffledElements
        let c = Int.random(in: 26...50)
        let k = elements.count - c
        elements.removeLast(k)
        let expectedResult = elements.sorted()
        
        elements.dutchFlagQuickSort(by: <)
        XCTAssertTrue(elements.elementsEqual(expectedResult), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: elements)
        coll.dutchFlagQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(expectedResult), "not sorted")
    }
    
    // MARK: - hoareQuickSort(by:) tests
    func testHoareQuickSort_whenIsEmpty_thenNothigChanges() {
        var sut = [Int]()
        sut.hoareQuickSort(by: <)
        XCTAssertTrue(sut.isEmpty)
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll<Int>(elements: [])
        coll.hoareQuickSort(by: <)
        XCTAssertTrue(coll.isEmpty)
    }
    
    func testHoareQuickSort_whenIsNotEmpty_thenSortsInPlace() {
        var sut = shuffledElements
        sut.hoareQuickSort(by: <)
        XCTAssertTrue(sut.elementsEqual(sortedElements), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: shuffledElements)
        coll.hoareQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(sortedElements), "not sorted")
    }
    
    func testHoareQuickSort_whenIsNotEmptyAndAlreadySorted_thenStaysSorted() {
        let sorted = Array(sortedElements)
        var sut = sorted
        sut.hoareQuickSort(by: <)
        XCTAssertTrue(sut.elementsEqual(sortedElements), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: sorted)
        coll.hoareQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(sortedElements), "not sorted")
    }
    
    func testHoareQuickSort_whenPredicateThrows_thenRethrows() {
        var sut = shuffledElements
        do {
            try sut.hoareQuickSort(by: alwaysThrowingPredicate)
        } catch {
            XCTAssertEqual(error as NSError, err)
            return
        }
        XCTFail("has not rethrown error")
    }
    
    func testHoareQuickSort_whenIsNotEmptyAndCountIsLessThanOrEqualtTo10_thenSortsInPlace() {
        var elements = shuffledElements
        let c = Int.random(in: 1...10)
        let k = elements.count - c
        elements.removeLast(k)
        let expectedResult = elements.sorted()
        
        elements.hoareQuickSort(by: <)
        XCTAssertTrue(elements.elementsEqual(expectedResult), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: elements)
        coll.hoareQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(expectedResult), "not sorted")
    }
    
    func testHoareQuickSort_whenCountIsBetween11And25_thenSortsInPlace() {
        var elements = shuffledElements
        let c = Int.random(in: 11...25)
        let k = elements.count - c
        elements.removeLast(k)
        let expectedResult = elements.sorted()
        
        elements.hoareQuickSort(by: <)
        XCTAssertTrue(elements.elementsEqual(expectedResult), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: elements)
        coll.hoareQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(expectedResult), "not sorted")
    }
    
    func testHoareQuickSort_whenCountIsBetween26And50_thenSortsInPlace() {
        var elements = shuffledElements
        let c = Int.random(in: 26...50)
        let k = elements.count - c
        elements.removeLast(k)
        let expectedResult = elements.sorted()
        
        elements.hoareQuickSort(by: <)
        XCTAssertTrue(elements.elementsEqual(expectedResult), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: elements)
        coll.hoareQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(expectedResult), "not sorted")
    }
    
    // MARK: - lomutuQuickSort(by:) tests
    func testLomutuQuickSort_whenIsEmpty_thenNothigChanges() {
        var sut = [Int]()
        sut.lomutuQuickSort(by: <)
        XCTAssertTrue(sut.isEmpty)
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll<Int>(elements: [])
        coll.lomutuQuickSort(by: <)
        XCTAssertTrue(coll.isEmpty)
    }
    
    func testLomutuQuickSort_whenIsNotEmpty_thenSortsInPlace() {
        var sut = shuffledElements
        sut.lomutuQuickSort(by: <)
        XCTAssertTrue(sut.elementsEqual(sortedElements), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: shuffledElements)
        coll.lomutuQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(sortedElements), "not sorted")
    }
    
    func testLomutuQuickSort_whenIsNotEmptyAndAlreadySorted_thenStaysSorted() {
        let sorted = Array(sortedElements)
        var sut = sorted
        sut.lomutuQuickSort(by: <)
        XCTAssertTrue(sut.elementsEqual(sortedElements), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: sorted)
        coll.lomutuQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(sortedElements), "not sorted")
    }
    
    func testLomutuQuickSort_whenPredicateThrows_thenRethrows() {
        var sut = shuffledElements
        do {
            try sut.lomutuQuickSort(by: alwaysThrowingPredicate)
        } catch {
            XCTAssertEqual(error as NSError, err)
            return
        }
        XCTFail("has not rethrown error")
    }
    
    func testLomutuQuickSort_whenIsNotEmptyAndCountIsLessThanOrEqualtTo10_thenSortsInPlace() {
        var elements = shuffledElements
        let c = Int.random(in: 1...10)
        let k = elements.count - c
        elements.removeLast(k)
        let expectedResult = elements.sorted()
        
        elements.lomutuQuickSort(by: <)
        XCTAssertTrue(elements.elementsEqual(expectedResult), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: elements)
        coll.lomutuQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(expectedResult), "not sorted")
    }
    
    func testLomutuQuickSort_whenCountIsBetween11And25_thenSortsInPlace() {
        var elements = shuffledElements
        let c = Int.random(in: 11...25)
        let k = elements.count - c
        elements.removeLast(k)
        let expectedResult = elements.sorted()
        
        elements.lomutuQuickSort(by: <)
        XCTAssertTrue(elements.elementsEqual(expectedResult), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: elements)
        coll.lomutuQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(expectedResult), "not sorted")
    }
    
    func testLomutuQuickSort_whenCountIsBetween26And50_thenSortsInPlace() {
        var elements = shuffledElements
        let c = Int.random(in: 26...50)
        let k = elements.count - c
        elements.removeLast(k)
        let expectedResult = elements.sorted()
        
        elements.lomutuQuickSort(by: <)
        XCTAssertTrue(elements.elementsEqual(expectedResult), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: elements)
        coll.lomutuQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(expectedResult), "not sorted")
    }
    
    // MARK: - dualPivotQuickSort(by:) tests
    func testDualPivotQuickSort_whenIsEmpty_thenNothigChanges() {
        var sut = [Int]()
        sut.dualPivotQuickSort(by: <)
        XCTAssertTrue(sut.isEmpty)
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll<Int>(elements: [])
        coll.dualPivotQuickSort(by: <)
        XCTAssertTrue(coll.isEmpty)
    }
    
    func testDualPivotQuickSort_whenIsNotEmpty_thenSortsInPlace() {
        var sut = shuffledElements
        sut.dualPivotQuickSort(by: <)
        XCTAssertTrue(sut.elementsEqual(sortedElements), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: shuffledElements)
        coll.dualPivotQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(sortedElements), "not sorted")
    }
    
    func testDualPivotQuickSort_whenIsNotEmptyAndAlreadySorted_thenStaysSorted() {
        let sorted = Array(sortedElements)
        var sut = sorted
        sut.dualPivotQuickSort(by: <)
        XCTAssertTrue(sut.elementsEqual(sortedElements), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: sorted)
        coll.dualPivotQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(sortedElements), "not sorted")
    }
    
    func testDualPivotQuickSort_whenPredicateThrows_thenRethrows() {
        var sut = shuffledElements
        do {
            try sut.dualPivotQuickSort(by: alwaysThrowingPredicate)
        } catch {
            XCTAssertEqual(error as NSError, err)
            return
        }
        XCTFail("has not rethrown error")
    }
    
    func testDualPivotQuickSort_whenIsNotEmptyAndCountIsLessThanOrEqualtTo46_thenSortsInPlace() {
        var elements = shuffledElements
        let c = Int.random(in: 1...46)
        let k = elements.count - c
        elements.removeLast(k)
        let expectedResult = elements.sorted()
        
        elements.dualPivotQuickSort(by: <)
        XCTAssertTrue(elements.elementsEqual(expectedResult), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: elements)
        coll.dualPivotQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(expectedResult), "not sorted")
    }
    
    func testDualPivotQuickSort_whenCountIsBetween47And150_thenSortsInPlace() {
        var elements = shuffledElements
        let c = Int.random(in: 47...150)
        let k = elements.count - c
        elements.removeLast(k)
        let expectedResult = elements.sorted()
        
        elements.dualPivotQuickSort(by: <)
        XCTAssertTrue(elements.elementsEqual(expectedResult))
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: elements)
        coll.dualPivotQuickSort(by: <)
        XCTAssertTrue(coll.elementsEqual(expectedResult), "not sorted")
    }
    
}
