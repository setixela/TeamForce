//
//  StackModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.06.2022.
//

import UIKit

struct StackEvents: InitProtocol {
   var addViewModel: Event<UIViewModel>?
   var addViewModels: Event<[UIViewModel]>?
}

final class StackModel: BaseViewModel<UIStackView> {
   var eventsStore: StackEvents = .init()

   override func start() {
      weak var wS = self

      onEvent(\.addViewModel) {
         wS?.view.addArrangedSubview($0.uiView)
      }
      .onEvent(\.addViewModels) {
         $0.forEach {
            wS?.view.addArrangedSubview($0.uiView)
         }
      }
   }
}

extension StackModel: Stateable {
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
      }
   }
}

extension StackModel: Communicable {
   typealias Events = StackEvents
}

enum StackState {
   case distribution(UIStackView.Distribution)
   case axis(NSLayoutConstraint.Axis)
   case spacing(CGFloat)
   case alignment(UIStackView.Alignment)
   case padding(UIEdgeInsets)
   case backColor(UIColor)
}
