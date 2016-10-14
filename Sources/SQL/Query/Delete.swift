// Delete.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2016 Formbound
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

public struct Delete: DeleteQuery {
  public let tableName: String
  public var condition: Condition? = nil
    
  public init(from tableName: String) {
    self.tableName = tableName
  }
}

public struct ModelDelete<T: Model>: DeleteQuery {
  public typealias ModelType = T
    
  public var tableName: String {
    return ModelType.tableName
  }
    
  public var condition: Condition? = nil
}

public protocol DeleteQuery: FilteredQuery, TableQuery {}

extension DeleteQuery {
  public init<T: Model>(from tableName: T.Type) {
    self.init(from: tableName)
  }
    
  public var queryComponents: QueryComponents {
    var queryComponents = QueryComponents(strings: ["DELETE", "FROM", tableName])
        
    if let condition = condition {
      queryComponents.append("WHERE")
      queryComponents.append(condition.queryComponents)
    }
        
    return queryComponents
  }
}