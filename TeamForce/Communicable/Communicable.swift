//
//  Communicable.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 17.06.2022.
//

import Foundation

// MARK: - KeyPath setable

protocol KeyPathSetable {}

extension KeyPathSetable {
    @discardableResult func set<T>(_ keypath: WritableKeyPath<Self, T>, _ value: T) -> Self {
        var slf = self
        slf[keyPath: keypath] = value
        return self
    }

    func get<T>(_ keypath: KeyPath<Self, T>, _ value: T) -> T {
        self[keyPath: keypath]
    }
}

// MARK: - Stateable

protocol Stateable: InitProtocol {
    associatedtype State

    func applyState(_ state: State)
}

extension Stateable {
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

// MARK: -  Stateable extensions

import UIKit

extension Stateable where Self: ViewModelProtocol, View: UIStackView {
   func applyState(_ state: StackState) {
      switch state {
      case .distribution(let value):
         view.distribution = value
      case .axis(let value):
         view.axis = value
      case .spacing(let value):
         view.spacing = value
      case .alignment(let value):
         view.alignment = value
      case .padding(let value):
         view.layoutMargins = value
         view.isLayoutMarginsRelativeArrangement = true
      case .backColor(let value):
         view.backgroundColor = value
      case .height(let value):
         view.addAnchors.constHeight(value)
      case .models(let models):
         models.forEach {
            view.addArrangedSubview($0.uiView)
         }
      case .cornerRadius(let value):
          view.layer.cornerRadius = value
      case .borderColor(let value):
          view.layer.borderColor = value.cgColor
      case .borderWidth(let value):
          view.layer.borderWidth = value
      }
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
        guard
            let lambda = eventsStore[keyPath: event]
        else {
            print("Event KeyPath did not observed!:\n   \(event)\n   Value: \(payload)")
            return self
        }

        DispatchQueue.main.async {
            lambda(payload)
        }

        return self
    }

    @discardableResult
    func sendEvent<T>(_ event: KeyPath<Events, Event<T>?>, _ payload: T) -> Self {
        return sendEvent(event, payload: payload)
    }

    @discardableResult
    func sendEvent(_ event: KeyPath<Events, Event<Void>?>) -> Self {
        guard
            let lambda = eventsStore[keyPath: event]
        else {
            print("Void Event KeyPath did not observed!:\n   \(event) ")
            return self
        }

        DispatchQueue.main.async {
            lambda(())
        }

        return self
    }

    @discardableResult
    func onEvent<T>(_ event: WritableKeyPath<Events, Event<T>?>, _ lambda: @escaping Event<T>) -> Self {
        eventsStore[keyPath: event] = lambda
        return self
    }
}
