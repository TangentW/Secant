//
//  Section.swift
//  Secant
//
//  Created by Tangent on 2020/6/22.
//

import DifferenceKit

public struct Section: Identifiable {
    
    public let id: AnyHashable
    
    public let header: AnyHeaderFooter?
    public let rows: [AnyRow]
    public let footer: AnyHeaderFooter?

    @inlinable
    public init<ID>(
        id: ID,
        @RowsBuilder rows: () -> Rows
    ) where ID: Hashable {
        self.init(id: id, rows: rows()._rows)
    }
    
    @inlinable
    public init<ID, Header>(
        id: ID,
        header: Header,
        @RowsBuilder rows: () -> Rows
    ) where ID: Hashable, Header: HeaderFooter {
        self.init(id: id, header: header.eraseToAnyHeaderFooter(), rows: rows()._rows)
    }
    
    @inlinable
    public init<ID, Footer>(
        id: ID,
        @RowsBuilder rows: () -> Rows,
        footer: Footer
    ) where ID: Hashable, Footer: HeaderFooter {
        self.init(id: id, rows: rows()._rows, footer: footer.eraseToAnyHeaderFooter())
    }
    
    @inlinable
    public init<ID, Header, Footer>(
        id: ID,
        header: Header,
        @RowsBuilder rows: () -> Rows,
        footer: Footer
    ) where ID: Hashable, Header: HeaderFooter, Footer: HeaderFooter {
        self.init(id: id, header: header.eraseToAnyHeaderFooter(), rows: rows()._rows, footer: footer.eraseToAnyHeaderFooter())
    }
    
    @inlinable
    public init<ID, Rows>(
        id: ID,
        header: AnyHeaderFooter? = nil,
        rows: Rows,
        footer: AnyHeaderFooter? = nil
    ) where ID: Hashable, Rows: Swift.Collection, Rows.Element == AnyRow {
        self.id = id
        self.header = header
        self.rows = Array(rows)
        self.footer = footer
    }
}

extension Section: DifferentiableSection {

    @inlinable
    public var elements: [AnyRow] { rows }
    
    @inlinable
    public init<C>(source: Section, elements: C) where C: Swift.Collection, C.Element == AnyRow {
        self.init(id: source.id, header: source.header, rows: elements, footer: source.footer)
    }
    
    @inlinable
    public var differenceIdentifier: AnyHashable { id }

    @inlinable
    public func isContentEqual(to source: Section) -> Bool {
        header.isContentEqual(to: source.header) && footer.isContentEqual(to: source.footer)
    }
}
