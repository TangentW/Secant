//
//  SectionsBuilder.Entry
//  Secant
//
//  Created by Tangent on 2020/6/22.
//

public protocol Sections {
    
    var _sections: [Section] { get }
}

@_functionBuilder
public struct SectionsBuilder {

    @inlinable
    public static func buildBlock(_ sections: Sections...) -> [Section] {
        sections.reduce(into: []) { $0 += $1._sections }
    }
    
    @inlinable
    public static func buildIf<S: Sections>(_ sections: S?) -> S? { sections }
    
    @inlinable
    public static func buildEither<S: Sections>(first: S) -> S { first }
    
    @inlinable
    public static func buildEither<S: Sections>(second: S) -> S { second }
}

// MARK: - Extension

extension Section: Sections {
    
    @inlinable
    public var _sections: [Section] { [self] }
}

extension Optional: Sections where Wrapped == Section {
    
    @inlinable
    public var _sections: [Section] {
        [self].compactMap { $0 }
    }
}

extension Array: Sections where Element == Section {
    
    @inlinable
    public var _sections: [Section] { self }
}
