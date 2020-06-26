//
//  Cancels.Composite.swift
//  Secant
//
//  Created by Tangent on 2020/6/23.
//

public extension Cancels {
    
    static func new(_ cancels: Cancellable...) -> Composite {
        .init(cancels)
    }
    
    static func new(_ cancels: [Cancellable]) -> Composite {
        .init(cancels)
    }
    
    struct Composite: Cancellable {
        
        public init(_ cancels: Cancellable...) {
            self.init(cancels)
        }
        
        public init(_ cancels: [Cancellable]) {
            _cancels = .init(cancels)
        }
        
        public func cancel() {
            let cancels = $_cancels.with { $0.take() }
            cancels?.forEach { $0.cancel() }
        }
        
        public func add(_ cancel: Cancellable) {
            let success = $_cancels.with {
                $0?.append(cancel)
            } != nil
            if !success {
                cancel.cancel()
            }
        }
        
        @Atom
        private var _cancels: LinkedList<Cancellable>?
    }
}
