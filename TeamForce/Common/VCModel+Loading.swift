//
//  VCModel+Loading.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.11.2022.
//

import ReactiveWorks
import UIKit

enum DarkLoadingState {
   case loading(onView: UIView?)
   case normal
}

final class DarkLoaderVM<Design: DSP>: ViewModel, Designable {
   private lazy var darkView = ViewModel()
      .backColor(.black)
      .alpha(0.5)
      .addModel(ActivityIndicator<Design>()) { anchors, superview in
         anchors
            .centerX(superview.centerXAnchor)
            .centerY(superview.centerYAnchor)
      }

   override func start() {
      super.start()
   }
}

extension DarkLoaderVM: StateMachine {
   func setState(_ state: DarkLoadingState) {
      switch state {
      case .loading(let view):
         if let view {
            view.addSubview(darkView.uiView)
            darkView.uiView.addAnchors.fitToView(view)
         }
      case .normal:
         darkView.uiView.removeFromSuperview()
      }
   }
}
