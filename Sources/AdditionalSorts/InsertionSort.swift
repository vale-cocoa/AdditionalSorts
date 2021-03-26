//
//  InsertionSort.swift
//  AdditionalSorts
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

extension MutableCollection where Self: RandomAccessCollection {
    public mutating func insertionSort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        let done = try withContiguousMutableStorageIfAvailable({ buff in
            let buffCount = buff.count
            guard
                buff.baseAddress != nil && buffCount > 0
            else { return true }
            
            try buff.insertionSorter(0..<buffCount, by: areInIncreasingOrder)
            
            return true
        }) ?? false
        if !done  {
            try insertionSorter(startIndex..<endIndex, by: areInIncreasingOrder)
        }
    }
    
    public mutating func insertionSortWithBinarySearch(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        let done: Bool = try withContiguousMutableStorageIfAvailable { buffer in
            try buffer.insertionSorterWithBinarySearch(buffer.startIndex..<buffer.endIndex, by: areInIncreasingOrder)
            
            return true
        } ?? false
        
        guard
            done
        else {
            try insertionSorterWithBinarySearch(startIndex..<endIndex, by: areInIncreasingOrder)
            
            return
        }
    }
    
    @inlinable
    mutating func insertionSorter(_ range: Range<Index>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let hi = index(before: range.upperBound)
        guard range.lowerBound < hi else { return }
            
        var i = index(after: range.lowerBound)
        while i < range.upperBound {
            var j = i
            INNER: while j > range.lowerBound {
                let prev = index(before: j)
                guard prev >= range.lowerBound else { break }
                
                if try areInIncreasingOrder(self[j], self[prev]) {
                    swapAt(j, prev)
                } else {
                    break INNER
                }
                j = prev
            }
            
            formIndex(after: &i)
        }
    }
    
    @usableFromInline
    mutating func insertionSorterWithBinarySearch(_ range: Range<Index>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        var idx = index(after: range.lowerBound)
        while idx < range.upperBound {
            let element = self[idx]
            let pos = try binarySearchInsertionIdx(of: element, in: range.lowerBound..<idx, sortedBy: areInIncreasingOrder)
            shiftElements(start: pos, limit: index(after: idx))
            self[pos] = element
            formIndex(after: &idx)
        }
    }
    
}

// MARK: - InsertionSortWithBinarySearch utilties
extension MutableCollection where Self: RandomAccessCollection {
    @usableFromInline
    mutating func shiftElements(start: Index, limit: Index) {
        var idx = index(before: limit)
        var prev = index(before: idx)
        while prev >= start {
            self[idx] = self[prev]
            idx = prev
            formIndex(before: &prev)
        }
    }
    
    func binarySearchInsertionIdx(of element: Element, in range: Range<Index>, sortedBy areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        guard
            range.lowerBound != range.upperBound
        else { return range.lowerBound }
        
        let lastIdx = index(before: range.upperBound)
        if range.lowerBound == lastIdx {
            if try areInIncreasingOrder(element, self[range.lowerBound]) {
                
                return range.lowerBound
            } else {
                
                return index(after: range.lowerBound)
            }
        }
        let midOffset = distance(from: range.lowerBound, to: range.upperBound) / 2
        let mid = index(range.lowerBound, offsetBy: midOffset)
        if try areInIncreasingOrder(self[mid], element) {
            
            return try binarySearchInsertionIdx(of: element, in: index(after: mid)..<range.upperBound, sortedBy: areInIncreasingOrder)
        } else if try areInIncreasingOrder(element, self[mid]) {
            
            return try binarySearchInsertionIdx(of: element, in: range.lowerBound..<mid, sortedBy: areInIncreasingOrder)
        }
        
        return mid
    }
    
}

