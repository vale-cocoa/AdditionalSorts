//
//  MergeSortsTests.swift
//  
//
//  Created by Valeriano Della Longa on 2021/03/18.
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

final class MergeSortsTests: XCTestCase {
    // MARK: - recursiveMergeSort(by:) tests
    func testRecursiveMergeSort_whenIsEmpty_thenNothigChanges() {
        var sut = [Int]()
        sut.recursiveMergeSort(by: <)
        XCTAssertTrue(sut.isEmpty)
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll<Int>(elements: [])
        coll.recursiveMergeSort(by: <)
        XCTAssertTrue(coll.isEmpty)
    }
    
    func testRecursiveMergeSort_whenIsNotEmpty_thenSortsInPlace() {
        var sut = shuffledElements
        sut.recursiveMergeSort(by: <)
        XCTAssertTrue(sut.elementsEqual(sortedElements), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: shuffledElements)
        coll.recursiveMergeSort(by: <)
        XCTAssertTrue(coll.elementsEqual(sortedElements), "not sorted")
    }
    
    func testRecursiveMergeSort_whenIsNotEmptyAndAlreadySorted_thenStaysSorted() {
        let sorted = Array(sortedElements)
        var sut = sorted
        sut.recursiveMergeSort(by: <)
        XCTAssertTrue(sut.elementsEqual(sortedElements), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: sorted)
        coll.recursiveMergeSort(by: <)
        XCTAssertTrue(coll.elementsEqual(sortedElements), "not sorted")
    }
    
    func testRecursiveMergeSort_whenPredicateThrows_thenRethrows() {
        var sut = shuffledElements
        do {
            try sut.recursiveMergeSort(by: alwaysThrowingPredicate)
        } catch {
            XCTAssertEqual(error as NSError, err)
            return
        }
        XCTFail("has not rethrown error")
    }
    
    // MARK: - iterativeMergeSort(by:) tests
    func testIterativeMergeSort_whenIsEmpty_thenNothigChanges() {
        var sut = [Int]()
        sut.iterativeMergeSort(by: <)
        XCTAssertTrue(sut.isEmpty)
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll<Int>(elements: [])
        coll.iterativeMergeSort(by: <)
        XCTAssertTrue(coll.isEmpty)
    }
    
    func testIterativeMergeSort_whenIsNotEmpty_thenSortsInPlace() {
        var sut = shuffledElements
        sut.iterativeMergeSort(by: <)
        XCTAssertTrue(sut.elementsEqual(sortedElements), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: shuffledElements)
        coll.iterativeMergeSort(by: <)
        XCTAssertTrue(coll.elementsEqual(sortedElements), "not sorted")
    }
    
    func testIterativeMergeSort_whenIsNotEmptyAndAlreadySorted_thenStaysSorted() {
        let sorted = Array(sortedElements)
        var sut = sorted
        sut.iterativeMergeSort(by: <)
        XCTAssertTrue(sut.elementsEqual(sortedElements), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: sorted)
        coll.iterativeMergeSort(by: <)
        XCTAssertTrue(coll.elementsEqual(sortedElements), "not sorted")
    }
    
    func testIterativeMergeSort_whenPredicateThrows_thenRethrows() {
        var sut = shuffledElements
        do {
            try sut.iterativeMergeSort(by: alwaysThrowingPredicate)
        } catch {
            XCTAssertEqual(error as NSError, err)
            return
        }
        XCTFail("has not rethrown error")
    }
    
    func testIterativeMergeSort_whenIsNotEmptyAndCountIsLessThanEqualTo20_thenSortsInPlace() {
        var elements = shuffledElements
        let c = Int.random(in: 1...20)
        let k = elements.count - c
        elements.removeLast(k)
        let expectedResult = elements.sorted()
        
        elements.iterativeMergeSort(by: <)
        XCTAssertTrue(elements.elementsEqual(expectedResult), "not sorted")
        
        // same test on collection not implementing withContiguousStorageIfAvailable
        var coll = Coll(elements: elements)
        coll.iterativeMergeSort(by: <)
        XCTAssertTrue(coll.elementsEqual(expectedResult), "not sorted")
    }
    
}
