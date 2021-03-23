//
//  TestsHelpers.swift
//  AdditionalSortsTests
//
//  Created by Valeriano Della Longa on 2021/03/17.
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

// MARK: - Useful constants and vars
let sortedElements = 1...500

var shuffledElements: Array<Int> { sortedElements.shuffled() }

let err = NSError(domain: "com.vdl.additionalSorts", code: 1, userInfo: nil)

let alwaysThrowingPredicate: (Int, Int) throws -> Bool = { _, _ in throw err }

// MARK: - 
// A MutableCollection NOT implementing
// withContiguousMutableStorageIfAvailble(_:) method
struct Coll<Element>: MutableCollection {
    var elements: [Element]
    
    var count: Int { elements.count }
    
    var isEmpty: Bool { elements.isEmpty }
    
    var startIndex: Int { 0 }
    
    var endIndex: Int { count }
    
    func index(after i: Int) -> Int { i + 1 }
    
    subscript(position: Int) -> Element {
        get {
            elements[position]
        }
        mutating set {
            elements[position] = newValue
        }
    }
    
}
