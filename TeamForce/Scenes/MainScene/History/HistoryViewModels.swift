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

   lazy var segmentedControl = SegmentedControlModel()
      .set(.items(["Все", "Получено", "Отправлено"]))
      .set(.height(50))
      .set(.selectedSegmentIndex(0))
}

enum SegmentControlState {
   case items([UIViewModel])
}

//final class SegmentControl<Design: DSP>: BaseViewModel<StackViewExtended>, Designable, Stateable2 {
//   typealias State = StackState
//   typealias State2 = SegmentControlState
//
//}
//
//extension SegmentControl {
//   func applyState(_ state: SegmentControlState) {
//      switch state {
//      case .items(let array):
//       //  items = array
//         //set_models(array)
//         break
//      }
//   }
//}

//struct SegmentControlButtonMode<WeakSelf>: WeakSelfied {
//   var inactive: Event<WeakSelf?>?
//   var selected: Event<WeakSelf?>?
//}

struct SegmentControlButtonMode: SceneModeProtocol {
   var normal: VoidEvent?
   var selected: VoidEvent?
}

final class SegmentControlButton<Design: DSP>: BaseViewModel<StackViewExtended>, Designable, SceneModable, Stateable {

   var modes: SegmentControlButtonMode = .init()

   typealias State = StackState

   private let button = ButtonModel()
   private let selector = ViewModel()
      .set_height(3)
      .set_backColor(Design.color.textError)
      .set_hidden(true)

   override func start() {
      set_distribution(.equalSpacing)
      onModeChanged(\.normal) { [weak self] in
         self?.button
            .set_textColor(Design.color.text)
            .set_hidden(true)
      }
      onModeChanged(\.selected) { [weak self] in
         self?.button
            .set_textColor(Design.color.textError)
            .set_hidden(false)
      }
      setMode(\.normal)
      set_arrangedModels([
         button,
         selector
      ])
   }

}
