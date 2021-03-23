//
//  QuickSortsPT.swift
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

final class QuickSortsPT: XCTestCase {
    func testDutchFlagQuickSort_Perfomance_whenIsNotSortedArray() {
        var sut = shuffledPerfomanceElements
        measure {
            sut.dutchFlagQuickSort(by: <)
        }
        
    }
    
    func testDutchFlagQuickSort_Performance_whenIsSortedArray() {
        var sut = Array(performanceSortedElements)
        measure {
            sut.dutchFlagQuickSort(by: <)
        }
    }
    
    func testHoareQuickSort_Perfomance_whenIsNotSortedArray() {
        var sut = shuffledPerfomanceElements
        measure {
            sut.hoareQuickSort(by: <)
        }
        
    }
    
    func testHoareQuickSort_Performance_whenIsSortedArray() {
        var sut = Array(performanceSortedElements)
        measure {
            sut.hoareQuickSort(by: <)
        }
    }
    
    func testLomutuQuickSort_Perfomance_whenIsNotSortedArray() {
        var sut = shuffledPerfomanceElements
        measure {
            sut.lomutuQuickSort(by: <)
        }
        
    }
    
    func testLomutuQuickSort_Performance_whenIsSortedArray() {
        var sut = Array(performanceSortedElements)
        measure {
            sut.lomutuQuickSort(by: <)
        }
    }
    
    func testDualPivotQuickSort_Perfomance_whenIsNotSortedArray() {
        var sut = shuffledPerfomanceElements
        measure {
            sut.dualPivotQuickSort(by: <)
        }
        
    }
    
    func testDualPivotQuickSort_Performance_whenIsSortedArray() {
        var sut = Array(performanceSortedElements)
        measure {
            sut.dualPivotQuickSort(by: <)
        }
    }
    
}
