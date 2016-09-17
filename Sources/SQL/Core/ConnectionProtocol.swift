// Connection.swift
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

@_exported import C7


/**
 *  ConnectionInfoProtocol is an adapter-specific protocol that holds necessary
 *  values to connect to a database. Associated with `ConnectionProtocol.ConnectionInfo`
 */
public protocol ConnectionInfoProtocol {
    var host: String { get }
    var port: Int { get }
    var databaseName: String { get }
    var username: String? { get }
    var password: String? { get }
    
    init(_ uri: URI) throws
}

public protocol ConnectionProtocol: class {
    associatedtype InternalStatus
    associatedtype Result: ResultProtocol
    associatedtype ConnectionProtocolError: Error
    associatedtype ConnectionInfo: ConnectionInfoProtocol
    
    var connectionInfo: ConnectionInfo { get }

    func open() throws

    func close()

    var internalStatus: InternalStatus { get }

    func execute(_ statement: QueryComponents) throws -> Result

    func begin() throws

    func commit() throws

    func rollback() throws

    func createSavePointNamed(_ name: String) throws

    func releaseSavePointNamed(_ name: String) throws

    func rollbackToSavePointNamed(_ name: String) throws

    init(_ info: ConnectionInfo)
    
    var mostRecentError: ConnectionProtocolError? { get }
    
    func executeInsertQuery<T: SQLDataConvertible>(query: InsertQuery, returningPrimaryKeyForField primaryKey: DeclaredField) throws -> T
}

public extension ConnectionProtocol {
    
    public init(_ uri: URI) throws {
        try self.init(ConnectionInfo(uri))
    }

    public func transaction(block: (Void) throws -> Void) throws {
        try begin()

        do {
            try block()
            try commit()
        }
        catch {
            try rollback()
            throw error
        }
    }

    public func withSavePointNamed(_ name: String, block: (Void) throws -> Void) throws {
        try createSavePointNamed(name)

        do {
            try block()
            try releaseSavePointNamed(name)
        }
        catch {
            try rollbackToSavePointNamed(name)
            try releaseSavePointNamed(name)
            throw error
        }
    }
    
    public func execute(_ statement: QueryComponents) throws -> Result {
        return try execute(statement)
    }
    
    public func execute(_ statement: String, parameters: [SQLDataConvertible?] = []) throws -> Result {
        return try execute(QueryComponents(statement, values: parameters.map { $0?.sqlData }))
    }
    
    public func execute(_ statement: String, parameters: SQLDataConvertible?...) throws -> Result {
        return try execute(statement, parameters: parameters)
    }

    public func execute(_ convertible: QueryComponentsConvertible) throws -> Result {
        return try execute(convertible.queryComponents)
    }

    public func begin() throws {
        _ = try execute("BEGIN")
    }

    public func commit() throws {
        _ = try execute("COMMIT")
    }

    public func rollback() throws {
        _ = try execute("ROLLBACK")
    }
}
