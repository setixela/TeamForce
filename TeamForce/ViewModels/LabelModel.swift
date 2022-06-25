//
//  LabelModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.06.2022.
//

import UIKit

final class LabelModel: BaseViewModel<PaddingLabel> {
    // var state: LabelState = .init()
}

extension LabelModel: Stateable {
    func applyState(_ state: LabelState) {
        switch state {
        case .text(let string):
            view.text = string
        case .font(let uIFont):
            view.font = uIFont
        case .color(let uIColor):
            view.textColor = uIColor
        case .numberOfLines(let int):
            view.numberOfLines = int
        case .alignment(let nSTextAlignment):
            view.textAlignment = nSTextAlignment
        case .padding(let uIEdgeInsets):
            view.padding = uIEdgeInsets
        }
    }
}
//
//protocol StateProtocol {
//    associatedtype State
//
//    var states: LinkedList<State> { get set }
//}
//
//final class LinkedList<T> {
//    var value: T?
//    var prev: LinkedList<T>?
//
//    init(value: T? = nil) {
//        self.value = value
//    }
//
//    @discardableResult
//    func add(_ value: T) -> LinkedList<T> {
//        if self.value == nil {
//            self.value = value
//            return self
//        }
//
//        let new = LinkedList(value: value)
//        new.prev = self
//
//        return new
//    }
//}

enum LabelState {
    case text(String)
    case font(UIFont)
    case color(UIColor)
    case numberOfLines(Int)
    case alignment(NSTextAlignment)
    case padding(UIEdgeInsets)
}

// final class LabelParams: StateProtocol {
//    enum State {
//        case text(String)
//        case font(UIFont)
//        case color(UIColor)
//        case numberOfLines(Int)
//        case alignment(NSTextAlignment)
//        case padding(UIEdgeInsets)
//    }
//
//    var states: LinkedList<State>
//
//    init(state: State) {
//        self.states = LinkedList(value: state)
//    }
//
//    @discardableResult
//    func `set`(_ state: State) -> Self {
//        let new = LinkedList(value: state)
//        new.prev = states
//        states = new
//
//        return self
//    }
// }
