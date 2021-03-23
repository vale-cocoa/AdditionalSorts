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

extension MutableCollection {
    public mutating func dutchFlagQuickSort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        let done: Bool = try withContiguousMutableStorageIfAvailable { buffer in
            let bufferCount = buffer.count
            guard
                buffer.baseAddress != nil,
                bufferCount > 0
            else { return true }
            
            try buffer.dutchFlagQSorter(lo: 0, hi: bufferCount - 1, by: areInIncreasingOrder)
            
            return true
        } ?? false
        
        guard done else {
            let lastOffset = distance(from: startIndex, to: endIndex) - 1
            let lastElementIdx = index(startIndex, offsetBy: lastOffset)
            try dutchFlagQSorter(lo: startIndex, hi: lastElementIdx, by: areInIncreasingOrder)
            
            return
        }
    }
    
    public mutating func hoareQuickSort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        let done: Bool = try withContiguousMutableStorageIfAvailable { buffer in
            try buffer.hoareQSorter(lo: buffer.startIndex, hi: buffer.index(before: buffer.endIndex), by: areInIncreasingOrder)
            
            return true
        } ?? false
        
        guard done else {
            let lastOffset = distance(from: startIndex, to: endIndex) - 1
            let lastIdx = index(startIndex, offsetBy: lastOffset)
            try hoareQSorter(lo: startIndex, hi: lastIdx, by: areInIncreasingOrder)
            
            return
        }
    }
    
    public mutating func lomutuQuickSort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        let done: Bool = try withContiguousMutableStorageIfAvailable { buffer in
            let bufferCount = buffer.count
            guard
                buffer.baseAddress != nil,
                bufferCount > 0
            else { return true }
            
            try buffer.lomutuQSorter(lo: 0, hi: (bufferCount - 1), by: areInIncreasingOrder)
            
            return true
        } ?? false
        
        guard done else {
            let lastOffset = distance(from: startIndex, to: endIndex) - 1
            let lastIdx = index(startIndex, offsetBy: lastOffset)
            try lomutuQSorter(lo: startIndex, hi: lastIdx, by: areInIncreasingOrder)
            
            return
        }
    }
    
    public mutating func dualPivotQuickSort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        let done: Bool = try withContiguousMutableStorageIfAvailable { buffer in
            let bufferCount = buffer.count
            guard
                buffer.baseAddress != nil,
                bufferCount > 0
            else { return true }
            
            try buffer.dualPivotQSorter(lo: 0, hi: (bufferCount - 1) , by: areInIncreasingOrder)
            
            return true
        } ?? false
        
        guard done else {
            let lastOffset = distance(from: startIndex, to: endIndex) - 1
            let lastIdx = index(startIndex, offsetBy: lastOffset)
            try dualPivotQSorter(lo: startIndex, hi: lastIdx, by: areInIncreasingOrder)
            
            return
        }
    }
    
    // DutchFlag
    mutating func dutchFlagQSorter(lo: Index, hi: Index, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard lo < hi  else { return }
        
        let lenght = distance(from: lo, to: hi) + 1
        guard lenght > 10 else {
            try insertionSortOn(lo..<(index(after: hi)), by: areInIncreasingOrder)
            
            return
        }
        let p = try pivot(within: lo..<index(after: hi), by: areInIncreasingOrder)
        swapAt(lo, p)
 
        var lt = lo
        var gt = hi
        var i = lo
        let v = self[lo]
        while i <= gt {
            if try areInIncreasingOrder(self[i], v) {
                swapAt(lt, i)
                formIndex(after: &lt)
                formIndex(after: &i)
            } else if try areInIncreasingOrder(v, self[i]) {
                swapAt(i, gt)
                let prevOffset = distance(from: startIndex, to: gt) - 1
                guard prevOffset >= 0 else { break }
                
                gt = index(startIndex, offsetBy: prevOffset)
            } else {
                formIndex(after: &i)
            }
        }
        let prevLtOffset = distance(from: startIndex, to: lt) - 1
        if prevLtOffset >= 0 {
            let prevLt = index(startIndex, offsetBy: prevLtOffset)
            try dutchFlagQSorter(lo: lo, hi: prevLt, by: areInIncreasingOrder)
        }
        try dutchFlagQSorter(lo: index(after: gt), hi: hi, by: areInIncreasingOrder)
    }
    
    // Hoare
    mutating func hoareQSorter(lo: Index, hi: Index, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard lo < hi else { return }
        
        let lenght = distance(from: lo, to: hi) + 1
        guard lenght > 10 else {
            try insertionSortWithBinarySearchOn(lo..<(index(after: hi)), by: areInIncreasingOrder)
            
            return
        }
        
        let p = try pivot(within: lo..<index(after: hi), by: areInIncreasingOrder)
        swapAt(lo, p)
        let pivot = try hoarePartition(lo: lo, hi: hi, by: areInIncreasingOrder)
        let prevPivotOffset = distance(from: lo, to: pivot)
        let prevPivot = index(lo, offsetBy: prevPivotOffset)
        try hoareQSorter(lo: lo, hi: prevPivot, by: areInIncreasingOrder)
        try hoareQSorter(lo: index(after: pivot), hi: hi, by: areInIncreasingOrder)
    }
    
    mutating func hoarePartition(lo: Index, hi: Index, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        let pivot = self[lo]
        var i = lo
        var j = index(after: hi)
        while true {
            repeat {
                if i == hi { break }
                formIndex(after: &i)
            } while try areInIncreasingOrder(self[i], pivot)
            
            repeat {
                if j == lo { break }
                let prevJOffset = distance(from: lo, to: j) - 1
                j = index(lo, offsetBy: prevJOffset)
            } while try areInIncreasingOrder(pivot, self[j])
            if i >= j { break }
            swapAt(i, j)
        }
        swapAt(lo, j)
        
        return j
    }
    
    // Lomutu
    mutating func lomutuQSorter(lo: Index, hi: Index, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard lo < hi else { return }
        
        let lenght = distance(from: lo, to: hi) + 1
        guard lenght > 10 else {
            try insertionSortWithBinarySearchOn(lo..<(index(after: hi)), by: areInIncreasingOrder)
            
            return
        }
        
        var p = try pivot(within: lo..<index(after: hi), by: areInIncreasingOrder)
        swapAt(hi, p)
        p = try lomutuPartition(lo: lo, hi: hi, by: areInIncreasingOrder)
        let prevPOffset = distance(from: startIndex, to: p) - 1
        let prevP = index(startIndex, offsetBy: prevPOffset)
        try lomutuQSorter(lo: lo, hi: prevP, by: areInIncreasingOrder)
        try lomutuQSorter(lo: index(after: p), hi: hi, by: areInIncreasingOrder)
    }
    
    mutating func lomutuPartition(lo: Index, hi: Index, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        let pivot = self[hi]
        
        var i = lo
        var j = lo
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
    mutating func dualPivotQSorter(lo: Index, hi: Index, by  areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard lo < hi else { return }
        
        let lenght = distance(from: lo, to: hi)
        guard
            lenght > 46
        else {
            try insertionSortWithBinarySearchOn(lo..<(index(after: hi)), by: areInIncreasingOrder)
            
            return
        }
        let offset = lenght / 3
        var mid1 = index(lo, offsetBy: offset)
        var mid2 = index(lo, offsetBy: (lenght - offset))
        let mid = index(lo, offsetBy: lenght / 2)
        if lenght <= 150 {
            mid1 = try medianOf(lo: lo, hi: mid, by: areInIncreasingOrder)
            mid2 = try medianOf(lo: index(after: mid), hi: hi, by: areInIncreasingOrder)
        } else {
            mid1 = try ninther(lo: lo, hi: mid, by: areInIncreasingOrder)
            mid2 = try ninther(lo: index(after: mid), hi: hi, by: areInIncreasingOrder)
        }
        swapAt(lo, mid1)
        swapAt(hi, mid2)
        
        let pivots = try dualPivotPartition(lo: lo, hi: hi, by: areInIncreasingOrder)
        
        let beforeLPOffset = distance(from: startIndex, to: pivots.lPivot) - 1
        let beforeLP = index(startIndex, offsetBy: beforeLPOffset)
        try dualPivotQSorter(lo: lo, hi: beforeLP, by: areInIncreasingOrder)
        let beforeRPOffset = distance(from: startIndex, to: pivots.rPivot) - 1
        let beforeRP = index(startIndex, offsetBy: beforeRPOffset)
        try dualPivotQSorter(lo: index(after: pivots.lPivot), hi: beforeRP, by: areInIncreasingOrder)
        try dualPivotQSorter(lo: index(after: pivots.rPivot), hi: hi, by: areInIncreasingOrder)
    }
    
    mutating func dualPivotPartition(lo: Index, hi: Index, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> (lPivot: Index, rPivot: Index) {
        if try areInIncreasingOrder(self[hi], self[lo]) {
            swapAt(lo, hi)
        }
        var l = index(after: lo)
        let beforeHiOffset = distance(from: startIndex, to: hi) - 1
        var r = index(startIndex, offsetBy: beforeHiOffset)
        var k = l
        let p = self[lo]
        let q = self[hi]
        
        while k <= r {
            if try areInIncreasingOrder(self[k], p) {
                swapAt(k, l)
                formIndex(after: &l)
            } else if try areInIncreasingOrder(self[k], q) == false {
                while try areInIncreasingOrder(q, self[r]) && k < r {
                    let beforeROffset = distance(from: startIndex, to: r) - 1
                    r = index(startIndex, offsetBy: beforeROffset)
                }
                swapAt(k, r)
                let beforeROffset = distance(from: startIndex, to: r) - 1
                r = index(startIndex, offsetBy: beforeROffset)
                if try areInIncreasingOrder(self[k], p) {
                    swapAt(k, l)
                    formIndex(after: &l)
                }
            }
            formIndex(after: &k)
        }
        let beforeLOffset = distance(from: startIndex, to: l) - 1
        l = index(startIndex, offsetBy: beforeLOffset)
        formIndex(after: &r)
        swapAt(lo, l)
        swapAt(hi, r)
        
        return (l, r)
    }
    
}

// MARK: - QuickSort on UnsafeMutableBufferPointer
extension UnsafeMutableBufferPointer {
    // DutchFlag
    mutating func dutchFlagQSorter(lo: Int, hi: Int, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard lo < hi  else { return }
        
        let lenght = hi - lo + 1
        guard lenght > 10 else {
            try insertionSortWithBinarySearchOn(lo..<(hi + 1), by: areInIncreasingOrder)
            
            return
        }
        let p = try pivot(within: lo..<(hi + 1), by: areInIncreasingOrder)
        swapAt(lo, p)
 
        var lt = lo
        var gt = hi
        var i = lo
        let v = self[lo]
        while i <= gt {
            if try areInIncreasingOrder(self[i], v) {
                swapAt(lt, i)
                lt += 1
                i += 1
            } else if try areInIncreasingOrder(v, self[i]) {
                swapAt(i, gt)
                gt -= 1
            } else {
                i += 1
            }
        }
        try dutchFlagQSorter(lo: lo, hi: (lt - 1), by: areInIncreasingOrder)
        try dutchFlagQSorter(lo: (gt + 1), hi: hi, by: areInIncreasingOrder)
    }
    
    // Hoare
    mutating func hoareQSorter(lo: Int, hi: Int, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard lo < hi else { return }
        
        let lenght = hi - lo + 1
        guard lenght > 10 else {
            try insertionSortWithBinarySearchOn(lo..<(hi + 1), by: areInIncreasingOrder)
            
            return
        }
        
        let p = try pivot(within: lo..<(hi + 1), by: areInIncreasingOrder)
        swapAt(lo, p)
        let pivot = try hoarePartition(lo: lo, hi: hi, by: areInIncreasingOrder)
        try hoareQSorter(lo: lo, hi: (pivot - 1), by: areInIncreasingOrder)
        try hoareQSorter(lo: pivot + 1, hi: hi, by: areInIncreasingOrder)
    }
    
    mutating func hoarePartition(lo: Int, hi: Int, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        let pivot = self[lo]
        var i = lo
        var j = hi + 1
        while true {
            repeat {
                if i == hi { break }
                i += 1
            } while try areInIncreasingOrder(self[i], pivot)
            
            repeat {
                if j == lo { break }
                j -= 1
            } while try areInIncreasingOrder(pivot, self[j])
            if i >= j { break }
            swapAt(i, j)
        }
        swapAt(lo, j)
        
        return j
    }
    
    // Lomutu
    mutating func lomutuQSorter(lo: Int, hi: Int, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard lo < hi else { return }
        
        let lenght = hi - lo + 1
        guard lenght > 10 else {
            try insertionSortWithBinarySearchOn(lo..<(hi + 1), by: areInIncreasingOrder)
            
            return
        }
        
        var p = try pivot(within: lo..<(hi + 1), by: areInIncreasingOrder)
        swapAt(hi, p)
        p = try lomutuPartition(lo: lo, hi: hi, by: areInIncreasingOrder)
        try lomutuQSorter(lo: lo, hi: (p - 1), by: areInIncreasingOrder)
        try lomutuQSorter(lo: (p + 1), hi: hi, by: areInIncreasingOrder)
    }
    
    mutating func lomutuPartition(lo: Int, hi: Int, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Index {
        let pivot = self[hi]
        var i = lo
        var j = lo
        while j < hi {
            if try areInIncreasingOrder(pivot, self[j]) == false {
                swapAt(i, j)
                i += 1
            }
            j += 1
        }
        swapAt(i, hi)
        
        return i
    }
    
    // DualPivot
    mutating func dualPivotQSorter(lo: Int, hi: Int, by  areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard lo < hi else { return }
        
        let lenght = hi - lo
        guard
            lenght > 46
        else {
            try insertionSortWithBinarySearchOn(lo..<(hi + 1), by: areInIncreasingOrder)
            
            return
        }
        let offset = lenght / 3
        var mid1 = lo + offset
        var mid2 = hi - offset
        let mid = lo + (lenght / 2)
        if lenght <= 150 {
            mid1 = try medianOf(lo: lo, hi: mid, by: areInIncreasingOrder)
            mid2 = try medianOf(lo: index(after: mid), hi: hi, by: areInIncreasingOrder)
        } else {
            mid1 = try ninther(lo: lo, hi: mid, by: areInIncreasingOrder)
            mid2 = try ninther(lo: index(after: mid), hi: hi, by: areInIncreasingOrder)
        }
        swapAt(lo, mid1)
        swapAt(hi, mid2)
        
        let pivots = try dualPivotPartition(lo: lo, hi: hi, by: areInIncreasingOrder)
        
        try dualPivotQSorter(lo: lo, hi: (pivots.lPivot - 1), by: areInIncreasingOrder)
        try dualPivotQSorter(lo: (pivots.lPivot + 1), hi: (pivots.rPivot - 1), by: areInIncreasingOrder)
        try dualPivotQSorter(lo: (pivots.rPivot + 1), hi: hi, by: areInIncreasingOrder)
    }
    
    mutating func dualPivotPartition(lo: Int, hi: Int, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> (lPivot: Index, rPivot: Index) {
        if try areInIncreasingOrder(self[hi], self[lo]) {
            swapAt(lo, hi)
        }
        var l = lo + 1
        var r = hi - 1
        var k = l
        let p = self[lo]
        let q = self[hi]
        
        while k <= r {
            if try areInIncreasingOrder(self[k], p) {
                swapAt(k, l)
                l += 1
            } else if try areInIncreasingOrder(self[k], q) == false {
                while try areInIncreasingOrder(q, self[r]) && k < r {
                    r -= 1
                }
                swapAt(k, r)
                r -= 1
                if try areInIncreasingOrder(self[k], p) {
                    swapAt(k, l)
                    l += 1
                }
            }
            k += 1
        }
        l -= 1
        r += 1
        swapAt(lo, l)
        swapAt(hi, r)
        
        return (l, r)
    }
    
}
