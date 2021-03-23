//
//  ShellSort.swift
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
    public mutating func shellSort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        
        let done: Bool = try withContiguousMutableStorageIfAvailable { buffer in
            try buffer._shellSort(by: areInIncreasingOrder)
            
            return true
        } ?? false
        
        guard done else {
            try _shellSort(by: areInIncreasingOrder)
            
            return
        }
    }
    
    @inline(__always)
    mutating func _shellSort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let lenght = count
        var h = _hLenght(lenght)
        while h >= 1 {
            INNER: for i in h..<lenght {
                var j = i
                var jIdx = index(startIndex, offsetBy: j)
                var hOffset = distance(from: startIndex, to: jIdx) - h
                guard hOffset >= 0 else { break INNER }
                
                var hIdx = index(startIndex, offsetBy: hOffset)
                INNERMOST: while
                    j >= h,
                    try areInIncreasingOrder(self[jIdx], self[hIdx])
                {
                    swapAt(jIdx, hIdx)
                    j -= h
                    guard j >= 0 else { break INNERMOST }
                    
                    jIdx = index(startIndex, offsetBy: j)
                    hOffset = distance(from: startIndex, to: jIdx) - h
                    guard hOffset >= 0 else { break INNERMOST }
                    hIdx = index(startIndex, offsetBy: hOffset)
                }
            }
            h /= 3
        }
    }
    
}

// MARK: - ShellSort on UnsafeMutableBufferPointer
extension UnsafeMutableBufferPointer {
    @inline(__always)
    mutating func _shellSort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let lenght = count
        var h = _hLenght(lenght)
        while h >= 1 {
            for i in h..<lenght {
                var j = i
                var hIdx = j - h
                while
                    j >= h,
                    try areInIncreasingOrder(self[j], self[hIdx])
                {
                    swapAt(j, hIdx)
                    j -= h
                    hIdx = j - h
                }
            }
            h /= 3
        }
    }
    
}

// MARK: - Private helper
@inline(__always)
fileprivate func _hLenght(_ lenght: Int) -> Int {
    var h = 1
    while h < lenght / 3 {
        h = 3 * h + 1
    }
    
    return h
}
