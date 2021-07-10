//
//  Events.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 04/05/21.
//

import Foundation

class Event {
    typealias EventHandler = () -> ()
    
    private var subscribers = [EventHandler]()
    
    /// Adds the given handler as a subscriber. Make sure to pass the handler parameter as a closure with `[weak self]` to avoid retain cycles and memory leaks.
    func addSubscriber(_ subscriber: @escaping EventHandler) {
        subscribers.append(subscriber)
    }
    
    func removeAllSubscribers() {
        subscribers.removeAll()
    }
    
    /// Notifies all the subscribers. In other words: Fire this event.
    func notify() {
        for subscriber in subscribers {
            subscriber()
        }
    }
}
