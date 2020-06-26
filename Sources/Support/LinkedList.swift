//
//  LinkedList.swift
//  Secant
//
//  Created by Tangent on 2020/6/22.
//

internal final class LinkedList<T> {
    
    typealias Remove = () -> Void
    
    private var _head: Node?
    private var _tail: Node?
    
    @inlinable
    init() { }
    
    init<C>(_ elements: C) where C: Collection, C.Element == T {
        _tail = elements.reduce(nil as Node?) { previous, element in
            let node = Node(element)
            if let previous = previous {
                node.previous = previous
                previous.next = node
            } else {
                _head = node
            }
            return node
        }
    }
}

extension LinkedList {
    
    @inlinable
    var isEmpty: Bool {
        _head == nil
    }
    
    func append(_ value: T) -> Remove {
        let node = Node(value)
        
        if let tail = _tail {
            tail.next = node
            node.previous = tail
            _tail = node
        } else {
            _head = node
            _tail = node
        }

        return { [weak node, weak self] in
            guard let node = node else { return }
            self?._remove(node)
        }
    }
}

extension LinkedList: Sequence {
    
    func makeIterator() -> AnyIterator<T> {
        var node: Node? = _head
        return .init {
            defer { node = node?.next }
            return node?.value
        }
    }
}

private extension LinkedList {
    
    func _remove(_ node: Node) {
        node.previous?.next = node.next
        node.next?.previous = node.previous
        
        if node === _head {
            _head = node.next
        }
        if node === _tail {
            _tail = node.previous
        }
        
        node.previous = nil
        node.next = nil
    }
}

private extension LinkedList {
    
    final class Node {
        
        let value: T
        
        @inlinable
        init(_ value: T) {
            self.value = value
        }
        
        weak var previous: Node?
        var next: Node?
    }
}
