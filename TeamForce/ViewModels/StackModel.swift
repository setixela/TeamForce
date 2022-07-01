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

enum StackState {
   case distribution(UIStackView.Distribution)
   case axis(NSLayoutConstraint.Axis)
   case spacing(CGFloat)
   case alignment(UIStackView.Alignment)
   case padding(UIEdgeInsets)
   case backColor(UIColor)
   case cornerRadius(CGFloat)
   case borderWidth(CGFloat)
   case borderColor(UIColor)
   case height(CGFloat)
   case models([UIViewModel])
}

// MARK: -  Stateable extensions

extension Stateable where Self: ViewModelProtocol, View: UIStackView {
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
      case .height(let value):
         view.addAnchors.constHeight(value)
      case .models(let models):
         view.subviews.forEach {
            $0.removeFromSuperview()
         }
         models.forEach {
            view.addArrangedSubview($0.uiView)
         }
      case .cornerRadius(let value):
         view.layer.cornerRadius = value
      case .borderColor(let value):
         view.layer.borderColor = value.cgColor
      case .borderWidth(let value):
         view.layer.borderWidth = value
      }
   }
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
