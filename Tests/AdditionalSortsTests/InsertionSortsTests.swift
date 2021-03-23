//
//  InsertionSortsTests.swift
//  AdditionalSortsTests
//
//  Created by Valeriano Della Longa on 2021/03/16.
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

final class InsertionSortsTests: XCTestCase {
    // MARK: - insertionSort(by:) tests
    func testInsertionSort_whenIsEmpty_thenNothingChanges() {
        var sut = [Int]()
        sut.insertionSort(by: <)
        XCTAssertTrue(sut.isEmpty)
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll<Int>(elements: [])
        coll.insertionSort(by: <)
        XCTAssertTrue(coll.isEmpty)
    }
    
    func testInsertionSort_whenIsNotEmpty_thenSortsInPlace() {
        var sut = shuffledElements
        sut.insertionSort(by: <)
        XCTAssertTrue(sut.elementsEqual(sortedElements), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: shuffledElements)
        coll.insertionSort(by: <)
        XCTAssertTrue(coll.elementsEqual(sortedElements), "not sorted")
    }
    
    func testInsertionSort_whenIsNotEmptyAndAlreadySorted_thenStaysSorted() {
        let sorted = Array(sortedElements)
        var sut = sorted
        sut.insertionSort(by: <)
        XCTAssertTrue(sut.elementsEqual(sortedElements), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: sorted)
        coll.insertionSort(by: <)
        XCTAssertTrue(coll.elementsEqual(sortedElements), "not sorted")
    }
    
    func testInsertionSort_whenPredicateThrows_thenRethrows() {
        var sut = shuffledElements
        do {
            try sut.insertionSort(by: alwaysThrowingPredicate)
        } catch {
            XCTAssertEqual(error as NSError, err)
            return
        }
        XCTFail("has not rethrown error")
    }
    
    // MARK: - insertionSortWithBinarySearch(by:) tests
    func testInsertionSortWithBinarySearch_whenIsEmpty_thenNothingChanges() {
        var sut = [Int]()
        sut.insertionSortWithBinarySearch(by: <)
        XCTAssertTrue(sut.isEmpty)
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll<Int>(elements: [])
        coll.insertionSortWithBinarySearch(by: <)
        XCTAssertTrue(coll.isEmpty)
    }
    
    func testInsertionSortWithBinarySearch_whenIsNotEmpty_thenSortsInPlace() {
        var sut = shuffledElements
        sut.insertionSortWithBinarySearch(by: <)
        XCTAssertTrue(sut.elementsEqual(sortedElements), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: shuffledElements)
        coll.insertionSortWithBinarySearch(by: <)
        XCTAssertTrue(coll.elementsEqual(sortedElements), "not sorted")
    }
    
    func testInsertionSortWithBinarySearch_whenIsNotEmptyAndAlreadySorted_thenStaysSorted() {
        let sorted = Array(sortedElements)
        var sut = sorted
        sut.insertionSortWithBinarySearch(by: <)
        XCTAssertTrue(sut.elementsEqual(sortedElements), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: sorted)
        coll.insertionSortWithBinarySearch(by: <)
        XCTAssertTrue(coll.elementsEqual(sortedElements), "not sorted")
    }
    
    func testInsertionSortWithBinarySearch_whenPredicateThrows_thenRethrows() {
        var sut = shuffledElements
        do {
            try sut.insertionSortWithBinarySearch(by: alwaysThrowingPredicate)
        } catch {
            XCTAssertEqual(error as NSError, err)
            return
        }
        XCTFail("has not rethrown error")
    }
    
}


