//
//  SegmentControlButtons.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.08.2022.
//

import ReactiveWorks

struct ButtonMode: ModeProtocol {
   var normal: Event<Void>?
   var selected: Event<Void>?
}

final class SegmentButton<Design: DSP>: BaseViewModel<StackViewExtended>, SegmentButtonModelProtocol
{
   var modes: ButtonMode = .init()
   var events: ButtonEvents = .init()

   typealias State = StackState

   private lazy var button = ButtonModel()

   private let selector = ViewModel()
      .height(3)
      .backColor(Design.color.textError)

   override func start() {

      button.view.contentVerticalAlignment = .top

      onModeChanged(\.normal) { [weak self] in
         self?.button
            .textColor(Design.color.text)
            .hidden(false)
         self?.selector
            .hidden(true)
      }

      onModeChanged(\.selected) { [weak self] in
         self?.button
            .textColor(Design.color.textError)
            .hidden(false)
         self?.selector
            .hidden(false)
      }
      setMode(\.normal)

      axis(.vertical)
      arrangedModels([
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
         $0.button.title(title)
      }

      return button
   }
}

protocol SegmentButtonModelProtocol: ButtonModelProtocol, Designable, Stateable, Modable
   where Mode == ButtonMode {}
