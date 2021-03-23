//
//  MergeSort.swift
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

extension MutableCollection {
    public mutating func recursiveMergeSort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        let done: Bool = try withContiguousMutableStorageIfAvailable { buffer in
            let buffCount = buffer.count
            guard
                buffer.baseAddress != nil,
                buffCount > 0
            else { return true }
            
            try buffer.recursiveMergeSortOn(0..<buffCount, by: areInIncreasingOrder)
            
            return true
        } ?? false
        
        guard done else {
            try recursiveMergeSortOn(startIndex..<endIndex, by: areInIncreasingOrder)
            
            return
        }
    }
    
    public mutating func iterativeMergeSort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        let done: Bool = try withContiguousMutableStorageIfAvailable { buffer in
            try buffer.iterativeMergeSorter(by: areInIncreasingOrder)
            
            return true
        } ?? false
        
        guard done else {
            try iterativeMergeSorter(by: areInIncreasingOrder)
            
            return
        }
    }
    
    mutating func recursiveMergeSortOn(_ range: Range<Index>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let hiOffset = distance(from: range.lowerBound, to: range.upperBound) - 1
        let hi = index(range.lowerBound, offsetBy: hiOffset)
        guard range.lowerBound < hi else { return }
        
        let midOffset = distance(from: range.lowerBound, to: hi) / 2
        guard midOffset > 10 else {
            try insertionSortOn(range, by: areInIncreasingOrder)
            
            return
        }
        
        let mid = index(range.lowerBound, offsetBy: midOffset)
        let afterMid = index(after: mid)
        try recursiveMergeSortOn(range.lowerBound..<afterMid, by: areInIncreasingOrder)
        try recursiveMergeSortOn(afterMid..<range.upperBound, by: areInIncreasingOrder)
        guard
            try areInIncreasingOrder(self[afterMid], self[mid])
        else { return }
        
        try mergeOn(range, mid: mid, by: areInIncreasingOrder)
    }
    
    @usableFromInline
    mutating func iterativeMergeSorter(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let lenght = count
        guard lenght > 20 else {
            try insertionSortOn(startIndex..<endIndex, by: areInIncreasingOrder)
            
            return
        }
        
        var size = 1
        while size < lenght {
            var lowerBoundOffset = 0
            while lowerBoundOffset < lenght - size {
                let lowerBound = index(startIndex, offsetBy: lowerBoundOffset)
                let mid = index(lowerBound, offsetBy: size - 1)
                let upperBoundOffset = Swift.min(lowerBoundOffset + 2 * size - 1, lenght - 1) + 1
                let upperBound = index(startIndex, offsetBy: upperBoundOffset)
                try mergeOn(lowerBound..<upperBound, mid: mid, by: areInIncreasingOrder)
                
                lowerBoundOffset += 2 * size
            }
            size *= 2
        }
    }
    
}

// MARK: - MergeSort on UnsafeMutableBufferPointer
extension UnsafeMutableBufferPointer {
    mutating func recursiveMergeSortOn(_ range: Range<Int>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let hi = range.upperBound - 1
        guard range.lowerBound < hi else { return }
        
        let midOffset = range.count / 2
        guard midOffset > 10 else {
            try insertionSortOn(range, by: areInIncreasingOrder)
            
            return
        }
        
        let mid = range.lowerBound + midOffset
        try recursiveMergeSortOn(range.lowerBound..<(mid + 1), by: areInIncreasingOrder)
        try recursiveMergeSortOn((mid + 1)..<range.upperBound, by: areInIncreasingOrder)
        
        guard
            try areInIncreasingOrder(self[mid + 1], self[mid])
        else { return }
        
        try mergeOn(range, mid: mid, by: areInIncreasingOrder)
    }
    
    @usableFromInline
    mutating func iterativeMergeSorter(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let lenght = count
        guard lenght > 20 else {
            try insertionSortOn(startIndex..<endIndex, by: areInIncreasingOrder)
            
            return
        }
        
        var size = 1
        while size < lenght {
            var lowerBound = 0
            while lowerBound < lenght - size {
                let mid = lowerBound + size - 1
                let upperBound = Swift.min(lowerBound + 2 * size - 1, lenght - 1) + 1
                try mergeOn(lowerBound..<upperBound, mid: mid, by: areInIncreasingOrder)
                lowerBound += 2 * size
            }
            size *= 2
        }
    }
    
}
