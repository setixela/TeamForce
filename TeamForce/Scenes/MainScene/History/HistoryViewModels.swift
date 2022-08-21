//
//  HistoryViewModels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 17.08.2022.
//

import Foundation
import ReactiveWorks
import UIKit

final class HistoryViewModels<Design: DesignProtocol>: Designable {
   lazy var tableModel = TableItemsModel<Design>()
      .set_backColor(Design.color.background)

//   lazy var selector = StackModel()
//      .set_axis(.horizontal)
//      .set_models([
//         SegmentControlButton(),
//         SegmentControlButton(),
//         SegmentControlButton(),
//      ])

   lazy var segmentedControl = SegmentControl<SegmentControl3Events, SegmentControlButton<Design>>()
      .set(.height(50))
//
//      .set(.items(["Все", "Получено", "Отправлено"]))
//      .set(.height(50))
//      .set(.selectedSegmentIndex(0))
}

protocol SegmentEventsProtocol: InitProtocol {
   func indexToEvent(_ index: Int) -> Event<Void>?
}

struct SegmentControl3Events: SegmentEventsProtocol {
   var selected1: Event<Void>?
   var selected2: Event<Void>?
   var selected3: Event<Void>?

   func indexToEvent(_ index: Int) -> Event<Void>? {
      switch index {
      case 1:
         return selected2
      case 2:
         return selected3
      default:
         return selected1
      }
   }
}

enum SegmentControlState {
   case items([UIViewModel])
}

final class SegmentControl<State2: SegmentEventsProtocol, Button: ButtonModelProtocol>:
   BaseViewModel<StackViewExtended>,
   Stateable2
{
   typealias State = StackState

   var eventsStore: SegmentControl3Events = .init()

   private lazy var buttons: [UIViewModel] = []

   override func start() {
      set_axis(.horizontal)
      set_distribution(.fillEqually)
      //  set_arrangedModels(buttons)
   }
}

extension SegmentControl {
   func applyState(_ state: SegmentControlState) {
      switch state {
      case .items(let array):
         buttons = array
         set_arrangedModels(buttons)
      }
   }
}

extension SegmentControl: Communicable {}

// struct SegmentControlButtonMode<WeakSelf>: WeakSelfied {
//   var inactive: Event<WeakSelf?>?
//   var selected: Event<WeakSelf?>?
// }

struct SegmentButtonMode: SceneModeProtocol {
   var normal: Event<Void>?
   var selected: Event<Void>?
}

final class SegmentControlButton<Design: DSP>: BaseViewModel<StackViewExtended>,
   ButtonModelProtocol,
   Designable,
   SceneModable,
   Stateable,
   Communicable
{
   var modes: SegmentButtonMode = .init()
   var eventsStore: ButtonEvents = .init()

   typealias State = StackState

   private lazy var button = ButtonModel()

   private let selector = ViewModel()
      .set_height(3)
      .set_backColor(Design.color.textError)
      .set_hidden(true)

   override func start() {
      onModeChanged(\.normal) { [weak self] in
         self?.button
            .set_textColor(Design.color.text)
            .set_hidden(false)
      }
      onModeChanged(\.selected) { [weak self] in
         self?.button
            .set_textColor(Design.color.textError)
            .set_hidden(false)
      }
      setMode(\.normal)
      set_arrangedModels([
         button,
         selector,
      ])

      button.onEvent(\.didTap) { [weak self]
         in self?.sendEvent(\.didTap)
      }
   }
}

extension SegmentControlButton {
   static func buttonWithTitle(_ title: String,
                               _ closure: @escaping () -> Void) -> SegmentControlButton
   {
      let button = SegmentControlButton<Design>()
      button.set {
         $0.button
            .set_title(title)
            .onEvent(\.didTap) { [weak button] in
               button?.setMode(\.selected)
               closure()
            }
      }

      return button
   }
}
