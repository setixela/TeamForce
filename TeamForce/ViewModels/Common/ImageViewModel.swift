//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import ReactiveWorks
import UIKit

enum TapGestureState {
   case tapGesturing
}

final class ImageViewModel: BaseViewModel<PaddingImageView>, Communicable {
   var events = ButtonEvents()

   override func start() {
      contentMode(.scaleAspectFit)
   }

   @objc func didTap() {
      sendEvent(\.didTap)
      print("Did tap")

      animateTap()
   }
}

extension ImageViewModel: Stateable3, ButtonTapAnimator {
   typealias State = ViewState
   typealias State2 = ImageViewState

   func applyState(_ state: TapGestureState) {
      switch state {
      case .tapGesturing:
         view.isUserInteractionEnabled = true
         view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
      }
   }
}
