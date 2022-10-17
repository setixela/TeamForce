//
//  SegmentControl3.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.08.2022.
//

import ReactiveWorks

protocol SegmentControlEventsProtocol: InitProtocol {
   func sendEventBy(index: Int)
}

struct SegmentControl2Events: SegmentControlEventsProtocol {
   var selected0: Event<Void>?
   var selected1: Event<Void>?

   func sendEventBy(index: Int) {
      switch index {
      case 0:
         selected0?(())
      default:
         selected1?(())
      }
   }
}

struct SegmentControl3Events: SegmentControlEventsProtocol {
   var selected0: Event<Void>?
   var selected1: Event<Void>?
   var selected2: Event<Void>?

   func sendEventBy(index: Int) {
      switch index {
      case 1:
         selected1?(())
      case 2:
         selected2?(())
      default:
         selected0?(())
      }
   }
}

enum SegmentControlState {
   case items([UIViewModel])
   case selected(Int)
}

final class SegmentControl<Button: SegmentButtonModelProtocol,
   Event: SegmentControlEventsProtocol>:
   BaseViewModel<StackViewExtended>, Stateable2
{
   typealias State = StackState

   var events: Event = .init()

   private lazy var _buttons: [UIViewModel] = []

   override func start() {
      axis(.horizontal)
      distribution(.fillEqually)
   }
}

extension SegmentControl {
   func applyState(_ state: SegmentControlState) {
      switch state {
      case .items(let array):
         _buttons = array
         arrangedModels(array)
         buttons.enumerated().forEach { index, model in
            model.on(\.didTap) { [weak self] in
               self?.unselectAll()
               self?.events.sendEventBy(index: index)
               model.setMode(\.selected)
            }
         }
      case .selected(let value):
         buttons[value].setMode(\.selected)
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
