//
//  HeapSort.swift
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
    public mutating func heapSort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        let done: Bool = try withContiguousMutableStorageIfAvailable { buffer in
            try buffer.heapSorter(by: areInIncreasingOrder)
            
            return true
        } ?? false
        guard done else {
            try heapSorter(by: areInIncreasingOrder)
            
            return
        }
    }
    
    @usableFromInline
    mutating func heapSorter(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        try buildMaxHeap(by: areInIncreasingOrder)
        var heapEndIndex = endIndex
        while heapEndIndex > startIndex {
            heapEndIndex = try heapRemove(heapEndIndex: heapEndIndex, by: areInIncreasingOrder)
        }
    }
    
}

// MARK: - HeapSort utilities
extension MutableCollection where Self: RandomAccessCollection {
    @usableFromInline
    mutating func heapRemove(heapEndIndex: Index, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        let last = index(before: heapEndIndex)
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
