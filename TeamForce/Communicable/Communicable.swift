//
//  Communicable.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 17.06.2022.
//

import Foundation

// MARK: - Setable

protocol Setable: AnyObject {}

extension Setable {
    @discardableResult func set<T>(_ keypath: WritableKeyPath<Self, T>, _ value: T) -> Self {
        var slf = self
        slf[keyPath: keypath] = value
        //  print(keypath, value)
        return self
    }
}

protocol Communicable: AnyObject {
    associatedtype Events: InitProtocol

    var eventsStore: Events { get set }
}

// MARK: - EnumStateable

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

       applyStates(state)
    }

    private func applyStates(_ states: [State]) {
        states.forEach {
            applyState($0)
        }
    }

//    @discardableResult
//    func updateState(_ closure: GenericClosure<State>) -> Self {
//        closure(state)
//        applyState()
//
//        return self
//    }

//    var updateState: State {
//        DispatchQueue.main.async { [weak self] in
//            self?.applyState()
//        }
//
//        return state
//    }

    @discardableResult
    func `set`(_ state: State) -> Self {
        applyState(state)

        return self
    }

    @discardableResult
    func `set`(_ state: [State]) -> Self {
        applyStates(state)

        return self
    }
}

// MARK: - Stateable

// protocol Stateable: AnyObject, InitProtocol {
//    associatedtype State: InitProtocol
//
//    var state: State { get set }
//
//    func applyState()
// }
//
// extension Stateable where Self: ViewModelProtocol {
//    init(state: State) {
//        self.init()
//
//        self.state = state
//        applyState()
//    }
// }
//
// extension Stateable {
//    @discardableResult
//    func updateState(_ closure: GenericClosure<State>) -> Self {
//        closure(state)
//        applyState()
//
//        return self
//    }
//
//    var updateState: State {
//        DispatchQueue.main.async { [weak self] in
//            self?.applyState()
//        }
//
//        return state
//    }
//
//    @discardableResult
//    func setState(_ state: State) -> Self {
//        self.state = state
//        applyState()
//
//        return self
//    }
// }

// MARK: - Communicable

extension Communicable {
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
        // print("\n", event, payload, "\n")
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

        print("On event:\n   \(event)\n   Lambda: \(String(describing: lambda))")
        return self
    }
}
