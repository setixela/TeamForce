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

extension StackModel: Stateable {}

extension StackModel: Communicable {
   typealias Events = StackEvents
}

enum TextState {
   case text(String)
   case font(UIFont)
}

//extension UIStackView {
//   /// Удаляет все subviews
//      func removeAllSubviews() {
//         let removedSubviews = arrangedSubviews.reduce([]) { subview, next -> [UIView] in
//            removeArrangedSubview(next)
//            return subview + [next]
//         }
//         NSLayoutConstraint.deactivate(removedSubviews.flatMap { $0.constraints })
//         removedSubviews.forEach { $0.removeFromSuperview() }
//         NSLayoutConstraint.deactivate(subviews.flatMap { $0.constraints })
//         subviews.forEach { $0.removeFromSuperview() }
//      }
//
//}
