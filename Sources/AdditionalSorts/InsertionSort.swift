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

extension MutableCollection {
    public mutating func insertionSort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        let done = try withContiguousMutableStorageIfAvailable({ buff in
            let buffCount = buff.count
            guard
                buff.baseAddress != nil && buffCount > 0
            else { return true }
            
            try buff.insertionSortOn(0..<buffCount, by: areInIncreasingOrder)
            
            return true
        }) ?? false
        if !done  {
            try insertionSortOn(startIndex..<endIndex, by: areInIncreasingOrder)
        }
    }
    
    public mutating func insertionSortWithBinarySearch(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        let done: Bool = try withContiguousMutableStorageIfAvailable { buffer in
            try buffer.insertionSortWithBinarySearchOn(buffer.startIndex..<buffer.endIndex, by: areInIncreasingOrder)
            
            return true
        } ?? false
        
        guard
            done
        else {
            try insertionSortWithBinarySearchOn(startIndex..<endIndex, by: areInIncreasingOrder)
            
            return
        }
    }
    
    @inlinable
    mutating func insertionSortOn(_ range: Range<Index>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let hiOffset = distance(from: range.lowerBound, to: range.upperBound) - 1
        let hi = index(range.lowerBound, offsetBy: hiOffset)
        guard range.lowerBound < hi else { return }
            
        var i = index(after: range.lowerBound)
        while i < range.upperBound {
            var j = i
            INNER: while j > range.lowerBound {
                let offsetToPreviousIndex = distance(from: startIndex, to: j) - 1
                let prev = index(startIndex, offsetBy: offsetToPreviousIndex)
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
    mutating func insertionSortWithBinarySearchOn(_ range: Range<Index>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
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

// MARK: - Insertion sort on UnsafeMutableBufferPointer
extension UnsafeMutableBufferPointer {
    @inlinable
    mutating func insertionSortOn(_ range: Range<Int>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let hi = range.upperBound - 1
        guard range.lowerBound < hi else { return }
            
        var i = range.lowerBound + 1
        while i < hi + 1 {
            var j = i
            INNER: while j > range.lowerBound {
                let prev = j - 1
                guard prev >= range.lowerBound else { break }
                
                if try areInIncreasingOrder(self[j], self[prev]) {
                    swapAt(j, prev)
                } else {
                    break INNER
                }
                j = prev
            }
            i += 1
        }
    }
    
    @usableFromInline
    mutating func insertionSortWithBinarySearchOn(_ range: Range<Int>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        var idx = range.lowerBound + 1
        while idx < range.upperBound {
            let element = self.baseAddress!.advanced(by: idx).move()
            let pos = try binarySearchInsertionIdx(of: element, in: range.lowerBound..<idx, sortedBy: areInIncreasingOrder)
            let countOfShifted = idx - pos
            if countOfShifted > 0 {
                let tmp = UnsafeMutablePointer<Element>.allocate(capacity: countOfShifted)
                tmp.moveInitialize(from: self.baseAddress!.advanced(by: pos), count: countOfShifted)
                self.baseAddress!.advanced(by: pos + 1).moveInitialize(from: tmp, count: countOfShifted)
                tmp.deallocate()
            }
            self.baseAddress!.advanced(by: pos).initialize(to: element)
            
            idx += 1
        }
    }
    
}
