//
//  QuickSort.swift
//  AdditionalSorts
//
//  Created by Valeriano Della Longa on 2021/03/19.
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
    public mutating func dutchFlagQuickSort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        let done: Bool = try withContiguousMutableStorageIfAvailable { buffer in
            try buffer.dutchFlagQSorter(0..<buffer.count, by: areInIncreasingOrder)
            
            return true
        } ?? false
        
        guard done else {
            try dutchFlagQSorter(startIndex..<endIndex, by: areInIncreasingOrder)
            
            return
        }
    }
    
    public mutating func hoareQuickSort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        let done: Bool = try withContiguousMutableStorageIfAvailable { buffer in
            try buffer.hoareQSorter(0..<buffer.count, by: areInIncreasingOrder)
            
            return true
        } ?? false
        
        guard done else {
            try hoareQSorter(startIndex..<endIndex, by: areInIncreasingOrder)
            
            return
        }
    }
    
    public mutating func lomutuQuickSort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        let done: Bool = try withContiguousMutableStorageIfAvailable { buffer in
            try buffer.lomutuQSorter(0..<buffer.count, by: areInIncreasingOrder)
            
            return true
        } ?? false
        
        guard done else {
            try lomutuQSorter(startIndex..<endIndex, by: areInIncreasingOrder)
            
            return
        }
    }
    
    public mutating func dualPivotQuickSort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        let done: Bool = try withContiguousMutableStorageIfAvailable { buffer in
            try buffer.dualPivotQSorter(0..<buffer.count, by: areInIncreasingOrder)
            
            return true
        } ?? false
        
        guard done else {
            try dualPivotQSorter(startIndex..<endIndex, by: areInIncreasingOrder)
            
            return
        }
    }
    
    // DutchFlag
    mutating func dutchFlagQSorter(_ range: Range<Index>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let hi = index(before: range.upperBound)
        guard range.lowerBound < hi  else { return }
        
        let lenght = distance(from: range.lowerBound, to: range.upperBound)
        guard lenght > 10 else {
            try insertionSorter(range, by: areInIncreasingOrder)
            
            return
        }
        let p = try pivot(range, by: areInIncreasingOrder)
        swapAt(range.lowerBound, p)
 
        var lt = range.lowerBound
        var gt = hi
        var i = range.lowerBound
        let v = self[range.lowerBound]
        while i <= gt {
            if try areInIncreasingOrder(self[i], v) {
                swapAt(lt, i)
                formIndex(after: &lt)
                formIndex(after: &i)
            } else if try areInIncreasingOrder(v, self[i]) {
                swapAt(i, gt)
                formIndex(before: &gt)
            } else {
                formIndex(after: &i)
            }
        }
        try dutchFlagQSorter(range.lowerBound..<lt, by: areInIncreasingOrder)
        try dutchFlagQSorter(index(after: gt)..<range.upperBound, by: areInIncreasingOrder)
    }
    
    // Hoare
    mutating func hoareQSorter(_ range: Range<Index>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let hi = index(before: range.upperBound)
        guard range.lowerBound < hi else { return }
        
        let lenght = distance(from: range.lowerBound, to: range.upperBound)
        guard lenght > 10 else {
            try insertionSorterWithBinarySearch(range, by: areInIncreasingOrder)
            
            return
        }
        
        let p = try pivot(range, by: areInIncreasingOrder)
        swapAt(range.lowerBound, p)
        let pivot = try hoarePartition(range, by: areInIncreasingOrder)
        try hoareQSorter(range.lowerBound..<pivot, by: areInIncreasingOrder)
        try hoareQSorter(index(after: pivot)..<range.upperBound, by: areInIncreasingOrder)
    }
    
    mutating func hoarePartition(_ range: Range<Index>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        let hi = index(before: range.upperBound)
        let pivot = self[range.lowerBound]
        var i = range.lowerBound
        var j = range.upperBound
        while true {
            repeat {
                if i == hi { break }
                formIndex(after: &i)
            } while try areInIncreasingOrder(self[i], pivot)
            
            repeat {
                if j == range.lowerBound { break }
                formIndex(before: &j)
            } while try areInIncreasingOrder(pivot, self[j])
            if i >= j { break }
            swapAt(i, j)
        }
        swapAt(range.lowerBound, j)
        
        return j
    }
    
    // Lomutu
    mutating func lomutuQSorter(_ range: Range<Index>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let hi = index(before: range.upperBound)
        guard range.lowerBound < hi else { return }
        
        let lenght = distance(from: range.lowerBound, to: range.upperBound)
        guard lenght > 10 else {
            try insertionSorterWithBinarySearch(range, by: areInIncreasingOrder)
            
            return
        }
        
        var p = try pivot(range, by: areInIncreasingOrder)
        swapAt(hi, p)
        p = try lomutuPartition(range, by: areInIncreasingOrder)
        try lomutuQSorter(range.lowerBound..<p, by: areInIncreasingOrder)
        try lomutuQSorter(index(after: p)..<range.upperBound, by: areInIncreasingOrder)
    }
    
    mutating func lomutuPartition(_ range: Range<Index>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        let hi = index(before: range.upperBound)
        let pivot = self[hi]
        
        var i = range.lowerBound
        var j = range.lowerBound
        while j < hi {
            if try areInIncreasingOrder(pivot, self[j]) == false {
                swapAt(i, j)
                formIndex(after: &i)
            }
            formIndex(after: &j)
        }
        swapAt(i, hi)
        
        return i
    }
    
    // DualPivot
    mutating func dualPivotQSorter(_ range: Range<Index>, by  areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let hi = index(before: range.upperBound)
        guard range.lowerBound < hi else { return }
        
        let lenght = distance(from: range.lowerBound, to: hi)
        guard
            lenght > 46
        else {
            try insertionSorterWithBinarySearch(range, by: areInIncreasingOrder)
            
            return
        }
        let offset = lenght / 3
        var mid1 = index(range.lowerBound, offsetBy: offset)
        var mid2 = index(hi, offsetBy: -offset)
        let mid = index(range.lowerBound, offsetBy: lenght / 2)
        let afterMid = index(after: mid)
        if lenght <= 150 {
            mid1 = try medianOf(range.lowerBound..<afterMid, by: areInIncreasingOrder)
            mid2 = try medianOf(afterMid..<range.upperBound, by: areInIncreasingOrder)
        } else {
            mid1 = try ninther(range.lowerBound..<afterMid, by: areInIncreasingOrder)
            mid2 = try ninther(afterMid..<range.upperBound, by: areInIncreasingOrder)
        }
        swapAt(range.lowerBound, mid1)
        swapAt(hi, mid2)
        let pivots = try dualPivotPartition(range, by: areInIncreasingOrder)
        try dualPivotQSorter(range.lowerBound..<pivots.lPivot, by: areInIncreasingOrder)
        try dualPivotQSorter(index(after: pivots.lPivot)..<pivots.rPivot, by: areInIncreasingOrder)
        try dualPivotQSorter(index(after: pivots.rPivot)..<range.upperBound, by: areInIncreasingOrder)
    }
    
    mutating func dualPivotPartition(_ range: Range<Index>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> (lPivot: Index, rPivot: Index) {
        let hi = index(before: range.upperBound)
        if try areInIncreasingOrder(self[hi], self[range.lowerBound]) {
            swapAt(range.lowerBound, hi)
        }
        var l = index(after: range.lowerBound)
        var r = index(before: hi)
        var k = l
        let p = self[range.lowerBound]
        let q = self[hi]
        
        while k <= r {
            if try areInIncreasingOrder(self[k], p) {
                swapAt(k, l)
                formIndex(after: &l)
            } else if try areInIncreasingOrder(self[k], q) == false {
                while try areInIncreasingOrder(q, self[r]) && k < r {
                    formIndex(before: &r)
                }
                swapAt(k, r)
                formIndex(before: &r)
                if try areInIncreasingOrder(self[k], p) {
                    swapAt(k, l)
                    formIndex(after: &l)
                }
            }
            formIndex(after: &k)
        }
        formIndex(before: &l)
        formIndex(after: &r)
        swapAt(range.lowerBound, l)
        swapAt(hi, r)
        
        return (l, r)
    }
    
}

// MARK: - QuickSort pivot utilties
extension MutableCollection where Self: RandomAccessCollection {
    @inline(__always)
    mutating func pivot(_ range: Range<Index>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        var pivot: Index!
        let lenght = distance(from: range.lowerBound, to: range.upperBound)
        if lenght <= 25 {
            pivot = index(range.lowerBound, offsetBy: lenght / 2)
        } else if lenght <= 50 {
            pivot = try medianOf(range, by: areInIncreasingOrder)
        } else {
            pivot = try ninther(range, by: areInIncreasingOrder)
        }
        
        return pivot
    }
    
    @inline(__always)
    mutating func medianOf(_ range: Range<Index>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        let midOffset = distance(from: range.lowerBound, to: range.upperBound) / 2
        let mid = index(range.lowerBound, offsetBy: midOffset)
        
        return try medianOfThree(lo: range.lowerBound, mid: mid, hi: index(before: range.upperBound), by: areInIncreasingOrder)
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
    mutating func ninther(_ range: Range<Index>, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        let lenght = distance(from: range.lowerBound, to: range.upperBound)
        var gap = lenght / 9
        if (lenght + gap) % 9 < gap { gap += 1 }
        let loM = try medianOfThree(lo: range.lowerBound, mid: index(range.lowerBound, offsetBy: gap), hi: index(range.lowerBound, offsetBy: 2 * gap), by: areInIncreasingOrder)
        let midM = try medianOfThree(lo: index(range.lowerBound, offsetBy: 3 * gap), mid: index(range.lowerBound, offsetBy: 4 * gap), hi: index(range.lowerBound, offsetBy: 5 * gap), by: areInIncreasingOrder)
        let hiM = try medianOfThree(lo: index(range.lowerBound, offsetBy: 6 * gap), mid: index(range.lowerBound, offsetBy: 7 * gap), hi: index(range.lowerBound, offsetBy: 8 * gap), by: areInIncreasingOrder)
        
        return try medianOfThree(lo: loM, mid: midM, hi: hiM, by: areInIncreasingOrder)
    }
    
}
