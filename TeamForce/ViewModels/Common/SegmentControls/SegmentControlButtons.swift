//
//  SegmentControlButtons.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.08.2022.
//

import ReactiveWorks

struct SegmentButtonMode: ModeProtocol {
   var normal: Event<Void>?
   var selected: Event<Void>?
}

final class SegmentButton<Design: DSP>: BaseViewModel<StackViewExtended>, SegmentButtonModelProtocol
{
   var modes: SegmentButtonMode = .init()
   var events: ButtonEvents = .init()

   typealias State = StackState

   private lazy var button = ButtonModel()

   private let selector = ViewModel()
      .set_height(3)
      .set_backColor(Design.color.textError)

   override func start() {

      button.view.contentVerticalAlignment = .top

      onModeChanged(\.normal) { [weak self] in
         self?.button
            .set_textColor(Design.color.text)
            .set_hidden(false)
         self?.selector
            .set_hidden(true)
      }

      onModeChanged(\.selected) { [weak self] in
         self?.button
            .set_textColor(Design.color.textError)
            .set_hidden(false)
         self?.selector
            .set_hidden(false)
      }
      setMode(\.normal)

      set_axis(.vertical)
      set_arrangedModels([
         button,
         selector,
      ])

      button.onEvent(\.didTap) { [weak self]
         in self?.sendEvent(\.didTap)
      }
   }
}

extension SegmentButton {
   static func withTitle(_ title: String) -> SegmentButton {
      let button = SegmentButton<Design>()
      button.set {
         $0.button.set_title(title)
      }

      return button
   }
}

protocol SegmentButtonModelProtocol: ButtonModelProtocol, Designable, Stateable, Modable
   where Mode == SegmentButtonMode {}
