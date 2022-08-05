//
//  FrameCellModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import UIKit
import ReactiveWorks

enum FrameCellState {
   case text(String)
   case header(String)
   case caption(String)
}

final class FrameCellModel<Design: DesignProtocol>: BaseViewModel<UIStackView>,
   Designable
{
   typealias State = StackState

   private lazy var headerLabel = Design.label.body2
   private lazy var textLabel = Design.label.counter
   private lazy var captionLabel = Design.label.caption

   override func start() {
      set(.axis(.vertical))
      set(.padding(.init(top: 12, left: 16, bottom: 12, right: 16)))
      set(.cornerRadius(Design.Parameters.cornerRadius))
      set(.models([
         headerLabel,
         textLabel,
         captionLabel
      ]))
   }
}

extension FrameCellModel: Stateable2 {
   func applyState(_ state: FrameCellState) {
      switch state {
      case .text(let string):
         textLabel.set(.text(string))
      case .header(let string):
         headerLabel.set(.text(string))
      case .caption(let string):
         captionLabel.set(.text(string))
      }
   }
}
