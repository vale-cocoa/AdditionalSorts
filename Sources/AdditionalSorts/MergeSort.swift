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

extension MutableCollection where Self: RandomAccessCollection {
    public mutating func recursiveMergeSort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        let done: Bool = try withContiguousMutableStorageIfAvailable { buffer in
            let buffCount = buffer.count
            guard
                buffer.baseAddress != nil,
                buffCount > 0
            else { return true }
            
            try buffer.recursiveMergeSorter(0..<buffCount, by: areInIncreasingOrder)
            
            return true
        } ?? false
        
        guard done else {
            try recursiveMergeSorter(startIndex..<endIndex, by: areInIncreasingOrder)
            
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
    
    mutating func recursiveMergeSorter(_ range: Range<Index>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        //let hiOffset = distance(from: range.lowerBound, to: range.upperBound) - 1
        //let hi = index(range.lowerBound, offsetBy: hiOffset)
        let hi = index(before: range.upperBound)
        guard range.lowerBound < hi else { return }
        
        let midOffset = distance(from: range.lowerBound, to: hi) / 2
        guard midOffset > 10 else {
            try insertionSorter(range, by: areInIncreasingOrder)
            
            return
        }
        
        let mid = index(range.lowerBound, offsetBy: midOffset)
        let afterMid = index(after: mid)
        try recursiveMergeSorter(range.lowerBound..<afterMid, by: areInIncreasingOrder)
        try recursiveMergeSorter(afterMid..<range.upperBound, by: areInIncreasingOrder)
        guard
            try areInIncreasingOrder(self[afterMid], self[mid])
        else { return }
        
        try mergeOn(range, mid: mid, by: areInIncreasingOrder)
    }
    
    @usableFromInline
    mutating func iterativeMergeSorter(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard count > 20 else {
            try insertionSorter(startIndex..<endIndex, by: areInIncreasingOrder)
            
            return
        }
        
        var size = 1
        while size < count {
            var lowerBoundOffset = 0
            while lowerBoundOffset < count - size {
                let lowerBound = index(startIndex, offsetBy: lowerBoundOffset)
                let mid = index(lowerBound, offsetBy: size - 1)
                let upperBoundOffset = Swift.min(lowerBoundOffset + 2 * size - 1, count - 1) + 1
                let upperBound = index(startIndex, offsetBy: upperBoundOffset)
                try mergeOn(lowerBound..<upperBound, mid: mid, by: areInIncreasingOrder)
                
                lowerBoundOffset += 2 * size
            }
            size *= 2
        }
    }
    
}

// MARK: - MergeSort utilities
extension MutableCollection where Self: RandomAccessCollection {
    @usableFromInline
    mutating func mergeOn(_ range: Range<Index>, mid: Index, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let slice = Array(self[range])
        let midDistance = distance(from: range.lowerBound, to: mid)
        let hi = index(before: range.upperBound)
        let hiDistance = distance(from: range.lowerBound, to: hi)
        var k = range.lowerBound
        var i = 0
        var j = midDistance + 1
        while k <= hi {
            if i > midDistance {
                self[k] = slice[j]
                j += 1
            } else if j > hiDistance {
                self[k] = slice[i]
                i += 1
            } else if try areInIncreasingOrder(slice[j], slice[i]) {
                self[k] = slice[j]
                j += 1
            } else {
                self[k] = slice[i]
                i += 1
            }
            formIndex(after: &k)
        }
    }
    
}
