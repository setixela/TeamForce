//
//  SegmentControl3.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.08.2022.
//

import ReactiveWorks

protocol SegmentControlEventsProtocol: InitProtocol {
   var selectedIndex: Event<Int>? { get set }
}

struct SegmentControl3Events: SegmentControlEventsProtocol {
   var selected1: Event<Void>?
   var selected2: Event<Void>?
   var selected3: Event<Void>?

   var selectedIndex: Event<Int>?
}

enum SegmentControlState {
   case items([UIViewModel])
}

final class SegmentControl<Button: SegmentButtonModelProtocol,
                           Event: SegmentControlEventsProtocol>:
   BaseViewModel<StackViewExtended>, Stateable2 {
   typealias State = StackState

   var eventsStore: Event = .init()

   private lazy var _buttons: [UIViewModel] = []

   override func start() {
      set_axis(.horizontal)
      set_distribution(.fillEqually)
   }
}

extension SegmentControl {
   func applyState(_ state: SegmentControlState) {
      switch state {
      case .items(let array):
         _buttons = array
         set_arrangedModels(array)
         buttons.enumerated().forEach { index, model in
            model.onEvent(\.didTap) { [weak self] in
               self?.unselectAll()
               self?.sendEvent(\.selectedIndex, index)
               model.setMode(\.selected)
            }
         }
      }
   }

   private var buttons: [Button] {
      _buttons as? [Button] ?? []
   }

   private func unselectAll() {
      buttons.forEach {
         $0.setMode(\.normal)
      }
   }
}

extension SegmentControl: Communicable {}
