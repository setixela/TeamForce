//
//  ScrollViewModels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.08.2022.
//

import ReactiveWorks
import UIKit

enum ScrollState {
   case models([UIViewModel])
   case spacing(CGFloat)
}

final class ScrollViewModelY: BaseViewModel<UIScrollView> {
   private lazy var stack = StackModel()
      .set_axis(.vertical)
      .set_distribution(.equalSpacing)

   private var spacing: CGFloat = 0

   override func start() {
      view.addSubview(stack.uiView)

      stack.view.addAnchors
         .top(view.topAnchor)
         .leading(view.leadingAnchor)
         .trailing(view.trailingAnchor)
         .bottom(view.bottomAnchor)
         .width(view.widthAnchor)

   }
}

extension ScrollViewModelY: Stateable2 {
   func applyState(_ state: ScrollState) {
      switch state {
      case .models(let array):
         array.forEach {
            stack.view.addArrangedSubview($0.uiView)
         }
      case .spacing(let value):
         stack.view.spacing = value
      }
   }
}

final class ScrollViewModelX: BaseViewModel<UIScrollView> {
   private lazy var stack = StackModel()
      .set_axis(.horizontal)

   private var spacing: CGFloat = 0

   override func start() {
      view.addSubview(stack.uiView)

      stack.view.addAnchors
         .top(view.topAnchor)
         .leading(view.leadingAnchor)
         .trailing(view.trailingAnchor)
         .height(view.heightAnchor)
   }
}

extension ScrollViewModelX: Stateable2 {
   func applyState(_ state: ScrollState) {
      switch state {
      case .models(let array):
         array.enumerated().forEach {
            stack.view.addArrangedSubview($0.1.uiView)
         }
      case .spacing(let value):
         stack.view.spacing = value
      }
   }
}
