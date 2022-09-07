//
//  LabelIconHorizontalModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import ReactiveWorks
import UIKit

struct LabelIconEvent: InitProtocol {
   var setText: Event<String>?
   var setImage: Event<UIImage>?
}

struct TappableEvent: InitProtocol {
   var startTapRecognizer: Void?
   var didTap: Void?
}

enum LabelIconState {
   case text(String)
   case image(UIImage)
}

final class LabelIconX<Design: DesignProtocol>: BaseViewModel<StackViewExtended>,
   Designable,
   Eventable
{
   typealias State = StackState

   typealias Events = TappableEvent
   var events = [Int: LambdaProtocol?]()

   let label = Design.label.body1
   let iconModel = ImageViewModel()

   required init() {
      super.init()
   }

   override func start() {
      set(.axis(.horizontal))
      set(.distribution(.fill))
      set(.alignment(.fill))
      set(.models([
         label,
         Spacer(),
         iconModel
      ]))

      on(\.startTapRecognizer) { [weak self] in
         guard let self = self else { return }

         self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTap)))
      }
   }

   @objc func didTap() {
      send(\.didTap)
   }
}

extension LabelIconX: Stateable2 {
   func applyState(_ state: LabelIconState) {
      switch state {
      case .text(let string):
         label.set(.text(string))
      case .image(let uIImage):
         iconModel.set(.image(uIImage))
      }
   }
}
