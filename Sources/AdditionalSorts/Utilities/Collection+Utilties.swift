//
//  Collection+Utilties.swift
//  AdditionalSorts
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

// MARK: - TimSort utilities
extension Collection {
    @inline(__always)
    func findNextRun(from start: Index, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> (end: Index, isDecreasing: Bool) {
        var prev = start
        var curr = index(after: start)
        guard curr < endIndex else { return (curr, false) }
        
        let isDecreasing = try areInIncreasingOrder(self[curr], self[prev])
        repeat {
            prev = curr
            formIndex(after: &curr)
        } while try curr < endIndex && isDecreasing == areInIncreasingOrder(self[curr], self[prev])
        
        return (curr, isDecreasing)
    }
    
    @inline(__always)
    func runCount(_ run: Range<Index>) -> Int {
        distance(from: run.lowerBound, to: run.upperBound)
    }
    
}
