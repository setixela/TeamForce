//
//  Communicable.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 17.06.2022.
//

import Foundation

// MARK: - Stateable

protocol Stateable: InitProtocol {
    associatedtype State

    func applyState(_ state: State)
}

extension Stateable where Self: ModelProtocol {
    init(_ state: State) {
        self.init()

        applyState(state)
    }

    init(_ state: [State]) {
        self.init()

        state.forEach { applyState($0) }
    }

    @discardableResult
    func set(_ state: State) -> Self {
        applyState(state)

        return self
    }

    @discardableResult
    func set(_ state: [State]) -> Self {
        state.forEach { applyState($0) }

        return self
    }
}

// MARK: - Communicable

protocol Communicable: AnyObject {
    associatedtype Events: InitProtocol

    var eventsStore: Events { get set }
}

extension Communicable {
    //
    @discardableResult
    func sendEvent<T>(_ event: KeyPath<Events, Event<T>?>, payload: T) -> Self {
        guard let lambda = eventsStore[keyPath: event] else {
            print("Event KeyPath did not observed!:\n   \(event)\n   Value: \(payload)")
            return self
        }

        lambda(payload)

        return self
    }

    @discardableResult
    func sendEvent<T>(_ event: KeyPath<Events, Event<T>?>, _ payload: T) -> Self {
        return sendEvent(event, payload: payload)
    }

    @discardableResult
    func sendEvent(_ event: KeyPath<Events, Event<Void>?>) -> Self {
        guard let lambda = eventsStore[keyPath: event] else {
            print("Void Event KeyPath did not observed!:\n   \(event) ")
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
