//
//  State.swift
//  Secant
//
//  Created by Tangent on 2020/6/22.
//

@propertyWrapper
@dynamicMemberLookup
public struct State<Value> {

    public typealias Listener = (Value) -> Void
    
    public var wrappedValue: Value {
        get { _box.read { $0 } }
        nonmutating set { _box.write { $0 = newValue } }
    }
    
    @inlinable
    public var projectedValue: Binding<Value> {
        .init(get: { self.wrappedValue }, set: { self.wrappedValue = $0 })
    }

    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> Binding<Subject> {
        .init(
            get: { self._box.read { $0[keyPath: keyPath] } },
            set: { new in
                self._box.write { $0[keyPath: keyPath] = new }
            }
        )
    }

    public init(wrappedValue: Value) {
        _box = .init(wrappedValue)
    }

    private let _box: _Box
}

public extension State {
    
    func listen(_ listener: @escaping Listener) -> Cancellable {
        _box.listen(listener)
    }
}

// MARK: - UpdatePublisher

internal protocol UpdatePublisher {
    
    func listen(update: @escaping () -> Void) -> Cancellable
}

extension State: UpdatePublisher {
    
    func listen(update updateListener: @escaping () -> Void) -> Cancellable {
        listen { _ in updateListener() }
    }
}

// MARK: - Box

private extension State {
    
    final class _Box {

        init(_ value: Value) {
            _value = value
            _listeners = .init()
        }
        
        private var _value: Value
        private var _listeners: LinkedList<Listener>
        private let _lock = Lock()
    }
}

extension State._Box {
    
    func read<T>(_ work: (Value) throws -> T) rethrows -> T {
        try _lock.with { try work(_value) }
    }
    
    func write(_ work: (inout Value) throws -> Void) rethrows {
        let (value, listeners): (Value, [State.Listener]) = try _lock.with {
            try work(&_value)
            return (_value, _listeners.map { $0 })
        }
        listeners.forEach {
            $0(value)
        }
    }
    
    func listen(_ listener: @escaping State.Listener) -> Cancellable {
        let cancel = _lock.with {
            _listeners.append(listener)
        }
        return Cancels.new { [weak self] in
            self?._lock.with(cancel)
        }
    }
}
