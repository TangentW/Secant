//
//  RowsBuilder.swift
//  Secant
//
//  Created by Tangent on 2020/6/22.
//

// MARK: - Rows

public protocol Rows {

    var _rows: [AnyRow] { get }
}

// MARK: - RowsBuilder

@_functionBuilder
public struct RowsBuilder {
    
    @inlinable
    public static func buildBlock(_ rows: Rows...) -> [AnyRow] {
        rows.reduce(into: []) { $0 += $1._rows }
    }

    @inlinable
    public static func buildIf<R: Rows>(_ rows: R?) -> R? { rows }
    
    @inlinable
    public static func buildEither<R: Rows>(first: R) -> R { first }
    
    @inlinable
    public static func buildEither<R: Rows>(second: R) -> R { second }
}

// MARK: - Extension

extension Optional: Rows where Wrapped: Row {
    
    @inlinable
    public var _rows: [AnyRow] {
        [self?.eraseToAnyRow()].compactMap { $0 }
    }
}

extension Array: Rows where Element: Row {
    
    @inlinable
    public var _rows: [AnyRow] {
        map { $0.eraseToAnyRow() }
    }
}
