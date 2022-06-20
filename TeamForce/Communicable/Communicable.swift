//
//  Communicable.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 17.06.2022.
//

import Foundation

protocol Communicable: AnyObject {
    associatedtype Events: InitProtocol

    var eventsStore: Events { get set }
}

extension Communicable {
    @discardableResult
    func sendEvent<T>(_ event: KeyPath<Events, Event<T>?>, payload: T) -> Self {
        guard let lambda = eventsStore[keyPath: event] else {
            print("Event KeyPath: \(event) did not observed!")
            return self
        }

        lambda(payload)

        return self
    }

    @discardableResult
    func sendEvent(_ event: KeyPath<Events, Event<Void>?>) -> Self {
        guard let lambda = eventsStore[keyPath: event] else {
            print("Void Event KeyPath: \(event) did not observed!")
            return self
        }

        lambda(())
        
        return self
    }

    @discardableResult
    func onEvent<T>(_ event: WritableKeyPath<Events, Event<T>?>, _ lambda: @escaping Event<T>) -> Self {
        eventsStore[keyPath: event] = lambda

        return self
    }
}
