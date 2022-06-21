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

protocol Stateable: AnyObject {
    associatedtype State: InitProtocol

    var state: State? { get set }

    func setState(_ state: State)
}

extension Stateable {

//    func setup(_ closure: GenericClosure<State>) {
//        let new = State()
//
//        closure(new)
//
//        DispatchQueue.main.async { [weak self] in
////        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
//            self?.state = new
//            self?.setState(new)
//        }
//    }

    func setup() -> State {
        let new = State()
        DispatchQueue.main.async { [weak self] in
//       DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.state = new
            self?.setState(new)
        }

        return new
    }
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
