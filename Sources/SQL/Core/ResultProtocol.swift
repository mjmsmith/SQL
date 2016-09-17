// Result.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Formbound
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

public protocol ResultStatus {
    var successful: Bool { get }
}

public protocol ResultProtocol: Collection {
    associatedtype FieldInfoProtocolType: FieldInfoProtocol
    associatedtype Iterator: RowIteratorProtocol = RowIterator

    func clear()

    var fields: [FieldInfoProtocolType] { get }

    subscript(index: Int) -> Row { get }

    var count: Int { get }
}

public protocol RowIteratorProtocol: IteratorProtocol {
    associatedtype Element: RowProtocol = Row
}

public struct RowIterator: RowIteratorProtocol {
    public typealias Element = Row

    let block: (Void) -> Element?
    var index: Int = 0

    init(block: @escaping (Void) -> Element?) {
        self.block = block
    }

    public func next() -> Element? {
        return block()
    }
}

extension ResultProtocol {

    public func makeIterator() -> RowIterator {
        var index = 0
        return RowIterator {
            if index < 0 || index >= self.count {
                return nil
            }

            let row = self[index]
            index += 1
            return row
        }
    }

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return count
    }
    
    public func index(after: Int) -> Int {
        return after + 1
    }
}
