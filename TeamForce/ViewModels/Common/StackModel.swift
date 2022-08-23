//
//  StackModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.06.2022.
//

import ReactiveWorks
import UIKit

class StackModel: BaseViewModel<StackViewExtended> {

   convenience init(_ models: UIViewModel...) {
      self.init()

      set_arrangedModels(models)
   }

   override func start() {
      set(.axis(.vertical))
   }
}

extension StackModel: Stateable2 {
   typealias State = StackState
   typealias State2 = ViewState
}

extension StackViewExtended {
   /// Удаляет все subviews
   func removeAllSubviews() {
      let removedSubviews = arrangedSubviews.reduce([]) { subview, next -> [UIView] in
         removeArrangedSubview(next)
         return subview + [next]
      }
      NSLayoutConstraint.deactivate(removedSubviews.flatMap { $0.constraints })
      removedSubviews.forEach { $0.removeFromSuperview() }
      NSLayoutConstraint.deactivate(subviews.flatMap { $0.constraints })
      subviews.forEach { $0.removeFromSuperview() }
   }
}

