//
//  Cancels.Simple.swift
//  Secant
//
//  Created by Tangent on 2020/6/22.
//

public extension Cancels {
    
    static func new(_ cancel: @escaping () -> Void) -> Simple {
        .init(cancel: cancel)
    }
    
    struct Simple: Cancellable {
        
        public init(cancel: @escaping () -> Void) {
            _cancel = cancel
        }
        
        @Atom
        private var _cancel: (() -> Void)?
        
        public func cancel() {
            $_cancel.with { $0.take() }?()
        }
    }
}
