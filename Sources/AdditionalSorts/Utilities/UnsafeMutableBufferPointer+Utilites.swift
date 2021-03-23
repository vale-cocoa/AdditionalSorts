//
//  UnsafeMutableBufferPointer+Utilites.swift
//  AdditionalSorts
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

// MARK: - InsertionSortWithBinarySearch utilities
extension UnsafeMutableBufferPointer {
    func binarySearchInsertionIdx(of element: Element, in range: Range<Int>, sortedBy areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        guard
            range.lowerBound != range.upperBound
        else { return range.lowerBound }
        
        if range.lowerBound == range.upperBound - 1 {
            if try areInIncreasingOrder(element, self[range.lowerBound]) {
                
                return range.lowerBound
            } else {
                
                return range.lowerBound + 1
            }
        }
        let midOffset = (range.upperBound - range.lowerBound) / 2
        let mid = range.lowerBound + midOffset
        if try areInIncreasingOrder(self[mid], element) {
            
            return try binarySearchInsertionIdx(of: element, in: (mid + 1)..<range.upperBound, sortedBy: areInIncreasingOrder)
        } else if try areInIncreasingOrder(element, self[mid]) {
            
            return try binarySearchInsertionIdx(of: element, in: range.lowerBound..<mid, sortedBy: areInIncreasingOrder)
        }
        
        return mid
    }
    
    @usableFromInline
    mutating func shiftElements(start: Int, limit: Int) {
        var idx = limit - 1
        var prev = idx - 1
        while prev >= start {
            self[idx] = self[prev]
            idx = prev
            prev -= 1
        }
    }
    
}

// MARK: - MergeSort utilities
extension UnsafeMutableBufferPointer {
    @usableFromInline
    mutating func mergeOn(_ range: Range<Int>, mid: Int, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let slice = Array(self[range])
        let midDistance = mid - range.lowerBound
        let hiDistance = distance(from: range.lowerBound, to: range.upperBound) - 1
        var k = range.lowerBound
        var i = 0
        var j = midDistance + 1
        while k <= (range.upperBound - 1) {
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
            k += 1
        }
    }
    
}

// MARK: - HeapSort utilities
extension UnsafeMutableBufferPointer {
    @usableFromInline
    mutating func heapRemove(heapEndIndex: Int, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        let last = heapEndIndex - 1
        swapAt(startIndex, last)
        try siftDown(from: startIndex, heapEndIndex: last, by: areInIncreasingOrder)
        
        return last
    }
    
    @usableFromInline
    mutating func buildMaxHeap(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        for i in stride(from: count / 2 - 1, through: 0, by: -1) {
            try siftDown(from: i, heapEndIndex: endIndex, by: areInIncreasingOrder)
        }
    }
    
    @inline(__always)
    func parent(of node: Int) -> Int {
        (node - 1) / 2
    }
    
    @inline(__always)
    func leftChild(of node: Int) -> Int {
        (node * 2) + 1
    }
    
    @inline(__always)
    func rightChild(of node: Int) -> Int {
        (node * 2) + 2
    }
    
}
