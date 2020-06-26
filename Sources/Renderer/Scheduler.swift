//
//  Scheduler.swift
//  Secant
//
//  Created by Tangent on 2020/6/23.
//

import Foundation

@usableFromInline
internal final class Scheduler {

    @usableFromInline
    let interval: TimeInterval

    @inlinable
    init(interval: TimeInterval) {
        self.interval = interval
    }

    @usableFromInline
    func schedule(immediately: Bool, _ work: @escaping () -> Void) {
        _workItem?.cancel()
        
        if immediately {
            work()
            return
        }
        
        let newItem = DispatchWorkItem { [weak self] in
            self?._workItem = nil
            work()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: newItem)
        _workItem = newItem
    }
    
    private weak var _workItem: DispatchWorkItem?
}
