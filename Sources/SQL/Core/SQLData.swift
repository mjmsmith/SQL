// Value.swift
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

import Foundation

public struct SQLDataConversionError: Error {
  public let description: String

  public init(description: String) {
    self.description = description
  }
}

public enum SQLData {
  case Text(String)
  case Binary(Data)
}

public protocol SQLDataConvertible {
  var sqlData: SQLData { get }

  init(rawSQLData: Data) throws
}

extension Int: SQLDataConvertible {
  public init(rawSQLData data: Data) throws {
    guard let string = String(data: data, encoding: .utf8),
          let value = Int(string) else {
      throw SQLDataConversionError(description: "Failed to convert data to Int")
    }
    
    self = value
  }

  public var sqlData: SQLData {
    return .Text(String(self))
  }
}

extension UInt: SQLDataConvertible {
  public init(rawSQLData data: Data) throws {
    guard let string = String(data: data, encoding: .utf8),
          let value = UInt(string) else {
      throw SQLDataConversionError(description: "Failed to convert data to UInt")
    }
    
    self = value
  }

  public var sqlData: SQLData {
    return .Text(String(self))
  }
}

extension Float: SQLDataConvertible {
  public init(rawSQLData data: Data) throws {
    guard let string = String(data: data, encoding: .utf8),
          let value = Float(string) else {
      throw SQLDataConversionError(description: "Failed to convert data to Float")
    }
      
    self = value
  }

  public var sqlData: SQLData {
    return .Text(String(self))
  }
}

extension Double: SQLDataConvertible {
  public init(rawSQLData data: Data) throws {
    guard let string = String(data: data, encoding: .utf8),
          let value = Double(string) else {
      throw SQLDataConversionError(description: "Failed to convert data to Double")
    }
    
    self = value
  }

  public var sqlData: SQLData {
    return .Text(String(self))
  }
}

extension String: SQLDataConvertible {
  public init(rawSQLData data: Data) throws {
    guard let value = String(data: data, encoding: .utf8) else {
      throw SQLDataConversionError(description: "Failed to convert data to Double")
    }
    
    self = value
  }

  public var sqlData: SQLData {
    return .Text(self)
  }
}

extension Data: SQLDataConvertible {
  public init(rawSQLData data: Data) throws {
    self = data
  }

  public var sqlData: SQLData {
    return .Binary(self)
  }
}
