//
//  SegmentControl3.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.08.2022.
//

import ReactiveWorks

struct SegmentControl3Events: InitProtocol {
   var selected1: Event<Void>?
   var selected2: Event<Void>?
   var selected3: Event<Void>?
}

enum SegmentControlState {
   case items([UIViewModel])
}

final class SegmentControl3<Button: SegmentButtonModelProtocol>: BaseViewModel<StackViewExtended>, Stateable2 {
   typealias State = StackState

   var eventsStore: SegmentControl3Events = .init()

   private lazy var _buttons: [UIViewModel] = []

   override func start() {
      set_axis(.horizontal)
      set_distribution(.fillEqually)
   }
}

extension SegmentControl3 {
   func applyState(_ state: SegmentControlState) {
      switch state {
      case .items(let array):
         _buttons = array
         set_arrangedModels(array)
         buttons.enumerated().forEach { index, model in
            switch index {
            // TODO: - ОБОБЩИТЬ!
            case 1:
               model.onEvent(\.didTap) { [weak self, weak model] in
                  self?.unselectAll()
                  self?.sendEvent(\.selected1)
                  model?.setMode(\.selected)
               }
            case 2:
               model.onEvent(\.didTap) { [weak self, weak model] in
                  self?.unselectAll()
                  self?.sendEvent(\.selected2)
                  model?.setMode(\.selected)
               }
            default:
               model.onEvent(\.didTap) { [weak self, weak model] in
                  self?.unselectAll()
                  self?.sendEvent(\.selected3)
                  model?.setMode(\.selected)
               }
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

extension SegmentControl3: Communicable {}
