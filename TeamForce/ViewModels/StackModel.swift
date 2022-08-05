//
//  StackModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.06.2022.
//

import ReactiveWorks
import UIKit

final class StackModel: BaseViewModel<UIStackView> {}

extension StackModel: Stateable {}

enum TextState {
   case text(String)
   case font(UIFont)
}

extension UIStackView {
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
