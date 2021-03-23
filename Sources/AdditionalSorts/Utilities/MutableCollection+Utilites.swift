//
//  MutableCollection+Utilites.swift
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

// MARK: - InsertionSortWithBinarySearch utilties
extension MutableCollection {
    @usableFromInline
    mutating func shiftElements(start: Index, limit: Index) {
        let beforeLimitOffset = distance(from: startIndex, to: limit) - 1
        var idx = index(startIndex, offsetBy: beforeLimitOffset)
        var prevOffset = beforeLimitOffset - 1
        var prev = index(startIndex, offsetBy: prevOffset)
        while prev >= start {
            self[idx] = self[prev]
            idx = prev
            prevOffset -= 1
            guard prevOffset >= 0 else { break }
            
            prev = index(startIndex, offsetBy: prevOffset)
        }
    }
    
    func binarySearchInsertionIdx(of element: Element, in range: Range<Index>, sortedBy areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        guard
            range.lowerBound != range.upperBound
        else { return range.lowerBound }
        
        let lastIdxOffset = distance(from: range.lowerBound, to: range.upperBound) - 1
        let lastIdx = index(range.lowerBound, offsetBy: lastIdxOffset)
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

// MARK: - MergeSort utilities
extension MutableCollection {
    @usableFromInline
    mutating func mergeOn(_ range: Range<Index>, mid: Index, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let slice = Array(self[range])
        let midDistance = distance(from: range.lowerBound, to: mid)
        let hiDistance = distance(from: range.lowerBound, to: range.upperBound) - 1
        let hi = index(range.lowerBound, offsetBy: hiDistance)
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

// MARK: - HeapSort utilities
extension MutableCollection {
    @usableFromInline
    mutating func heapRemove(heapEndIndex: Index, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        let lastOffset = distance(from: startIndex, to: heapEndIndex) - 1
        let last = index(startIndex, offsetBy: lastOffset)
        swapAt(startIndex, last)
        try siftDown(from: startIndex, heapEndIndex: last, by: areInIncreasingOrder)
        
        return last
    }
    
    @usableFromInline
    mutating func buildMaxHeap(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        for i in stride(from: count / 2 - 1, through: 0, by: -1) {
            let node = index(startIndex, offsetBy: i)
            try siftDown(from: node, heapEndIndex: endIndex, by: areInIncreasingOrder)
        }
    }
    
    @usableFromInline
    mutating func siftUp(from node: Index, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        var child = node
        var p = parent(of: child)
        while child > startIndex {
            guard
                try areInIncreasingOrder(self[p], self[child])
            else { break }
            
            swapAt(child, p)
            child = p
            p = parent(of: child)
        }
    }
    
    @usableFromInline
    mutating func siftDown(from node: Index, heapEndIndex: Index, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows{
        var parent = node
        while true {
            let left = leftChild(of: parent)
            let right = rightChild(of: parent)
            var candidate = parent
            if left < heapEndIndex {
                if try areInIncreasingOrder(self[candidate], self[left]) {
                    candidate = left
                }
            }
            if right < heapEndIndex {
                if try areInIncreasingOrder(self[candidate], self[right]) {
                    candidate = right
                }
            }
            if candidate == parent {
                return
            }
            swapAt(parent, candidate)
            parent = candidate
        }
    }
    
    @usableFromInline
    func parent(of node: Index) -> Index {
        let nodeOffest = distance(from: startIndex, to: node)
        let parentOffset = (nodeOffest - 1) / 2
        
        return index(startIndex, offsetBy: parentOffset)
    }
    
    @usableFromInline
    func leftChild(of node: Index) -> Index {
        let nodeOffset = distance(from: startIndex, to: node)
        let leftChildOffset = (nodeOffset * 2) + 1
        
        return index(startIndex, offsetBy: leftChildOffset)
    }
    
    @usableFromInline
    func rightChild(of node: Index) -> Index {
        let nodeOffset = distance(from: startIndex, to: node)
        let rightChildOffset = (nodeOffset * 2) + 2
        
        return index(startIndex, offsetBy: rightChildOffset)
    }
    
}

// MARK: - QuickSort utilties
extension MutableCollection {
    @inline(__always)
    mutating func pivot(within range: Range<Index>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        var pivot: Index!
        let lenght = distance(from: range.lowerBound, to: range.upperBound)
        if lenght <= 25 {
            pivot = index(range.lowerBound, offsetBy: lenght / 2)
        } else if lenght <= 50 {
            pivot = try medianOf(lo: range.lowerBound, hi: index(range.lowerBound, offsetBy: lenght - 1), by: areInIncreasingOrder)
        } else {
            pivot = try ninther(lo: range.lowerBound, hi: index(range.lowerBound, offsetBy: lenght - 1), by: areInIncreasingOrder)
        }
        
        return pivot
    }
    
    @inline(__always)
    mutating func medianOf(lo: Index, hi: Index, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        let midOffset = (distance(from: lo, to: hi) + 1) / 2
        let mid = index(lo, offsetBy: midOffset)
        
        return try medianOfThree(lo: lo, mid: mid, hi: hi, by: areInIncreasingOrder)
    }
    
    @inlinable
    mutating func medianOfThree(lo: Index, mid: Index, hi: Index, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        if try areInIncreasingOrder(self[mid], self[lo]) {
            swapAt(lo, mid)
        }
        if try areInIncreasingOrder(self[hi], self[lo]) {
            swapAt(hi, lo)
        }
        if try areInIncreasingOrder(self[hi], self[mid]) {
            swapAt(hi, mid)
        }
        
        return mid
    }
    
    @usableFromInline
    mutating func ninther(lo: Index, hi: Index, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        let lenght = distance(from: lo, to: hi) + 1
        var gap = lenght / 9
        if (lenght + gap) % 9 < gap { gap += 1 }
        let loM = try medianOfThree(lo: lo, mid: index(lo, offsetBy: gap), hi: index(lo, offsetBy: 2 * gap), by: areInIncreasingOrder)
        let midM = try medianOfThree(lo: index(lo, offsetBy: 3 * gap), mid: index(lo, offsetBy: 4 * gap), hi: index(lo, offsetBy: 5 * gap), by: areInIncreasingOrder)
        let hiM = try medianOfThree(lo: index(lo, offsetBy: 6 * gap), mid: index(lo, offsetBy: 7 * gap), hi: index(lo, offsetBy: 8 * gap), by: areInIncreasingOrder)
        
        return try medianOfThree(lo: loM, mid: midM, hi: hiM, by: areInIncreasingOrder)
    }
    
}

// MARK: - TimSort utilites
extension MutableCollection {
    @usableFromInline
    mutating func reverseWithin(_ range: Range<Index>) {
        var i = range.lowerBound
        var j = range.upperBound
        while i < j {
            let offsetToBeforeJ = distance(from: startIndex, to: j) - 1
            guard offsetToBeforeJ >= 0 else { break }
            //formIndex(before: &j)
            j = index(startIndex, offsetBy: offsetToBeforeJ)
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
    
}
