//
//  TimSort.swift
//  AdditionalSorts
//
//  Created by Valeriano Della Longa on 2021/03/20.
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

extension MutableCollection where Self: RandomAccessCollection {
    public mutating func timSort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        let minRL = minimumRunLenght(count)
        guard count > minRL else {
            try insertionSortWithBinarySearch(by: areInIncreasingOrder)
            
            return
        }
        
        let done: Bool = try withContiguousMutableStorageIfAvailable { buffer in
            try buffer.timSorter(minimumRunLenght: minRL, by: areInIncreasingOrder)
            
            return false
        } ?? false
        
        guard done else {
            try timSorter(minimumRunLenght: minRL, by: areInIncreasingOrder)
            
            return
        }
    }
    
    mutating func timSorter(minimumRunLenght: Int, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        var runs = [Range<Index>]()
        var start = startIndex
        while start < endIndex {
            var (end, decreasing) = try findNextRun(from: start, by: areInIncreasingOrder)
            if decreasing {
                reverseWithin(start..<end)
            }
            if end < endIndex && distance(from: start, to: end) < minimumRunLenght {
                let newEnd = Swift.min(endIndex, index(start, offsetBy: minimumRunLenght))
                try insertionSorterWithBinarySearch(start..<newEnd, by: areInIncreasingOrder)
                end = newEnd
            }
            runs.append(start..<end)
            try mergeTopRuns(&runs, by: areInIncreasingOrder)
            start = end
        }
        try finalizeRuns(&runs, by: areInIncreasingOrder)
    }
    
    mutating func finalizeRuns(_ runs: inout [Range<Index>], by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        while runs.count > 1 {
            try mergeRuns(&runs, at: runs.count - 1, by: areInIncreasingOrder)
        }
    }
    
    mutating func mergeTopRuns(_ runs: inout [Range<Index>], by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        while runs.count > 1 {
            var lastIdx = runs.count - 1
            if lastIdx >= 3 && (runCount(runs[lastIdx - 3]) <= runCount(runs[lastIdx - 2]) + runCount(runs[lastIdx - 1])) {
                if runCount(runs[lastIdx - 2]) < runCount(runs[lastIdx]) {
                    lastIdx -= 1
                }
            } else if lastIdx >= 2 && (runCount(runs[lastIdx - 2]) <= runCount(runs[lastIdx - 1]) + runCount(runs[lastIdx])) {
                if runCount(runs[lastIdx - 2]) < runCount(runs[lastIdx]) {
                    lastIdx -= 1
                }
            } else if runCount(runs[lastIdx - 1]) <= runCount(runs[lastIdx]) {
                
            } else {
                break
            }
            try mergeRuns(&runs, at: lastIdx, by: areInIncreasingOrder)
        }
    }
    
    mutating func mergeRuns(_ runs: inout [Range<Index>], at i: Int, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let lo = runs[i - 1].lowerBound
        let mid = runs[i].lowerBound
        let hi = runs[i].upperBound
        try timSortMerge(lo: lo, mid: mid, hi: hi, by: areInIncreasingOrder)
        runs[i - 1] = lo..<hi
        runs.remove(at: i)
    }
    
    mutating func timSortMerge(lo: Index, mid: Index, hi: Index, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let left = Array<Element>(self[lo..<mid])
        let right = Array<Element>(self[mid..<hi])
        var i = 0
        var j = 0
        var k = lo
        while i < left.count && j < right.count {
            if try areInIncreasingOrder(right[j], left[i]) {
                self[k] = right[j]
                j += 1
            } else {
                self[k] = left[i]
                i += 1
            }
            formIndex(after: &k)
        }
        while i < left.count {
            self[k] = left[i]
            i += 1
            formIndex(after: &k)
        }
        while j < right.count {
            self[k] = right[j]
            j += 1
            formIndex(after: &k)
        }
    }
    
}

// MARK: - TimSort utilites
extension MutableCollection where Self: RandomAccessCollection {
    @usableFromInline
    mutating func reverseWithin(_ range: Range<Index>) {
        var i = range.lowerBound
        var j = range.upperBound
        while i < j {
            formIndex(before: &j)
            swapAt(i, j)
            formIndex(after: &i)
        }
    }
    
    @inline(__always)
    func minimumRunLenght(_ c: Int) -> Int {
        let bitToUse = 6
        if c < 1 << bitToUse { return c }
        let offset = (Int.bitWidth - bitToUse) - c.leadingZeroBitCount
        let mask = (1 << offset) - 1
        
        return c >> offset + (c & mask == 0 ? 0 : 1)
    }
    
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
