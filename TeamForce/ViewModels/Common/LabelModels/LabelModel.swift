//
//  LabelModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.06.2022.
//

import ReactiveWorks
import UIKit

final class LabelModel: BaseViewModel<PaddingLabel>, Eventable {
   typealias Events = ButtonEvents
   var events = [Int: LambdaProtocol?]()
   
   func makeTappable() {
      let labelTap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
      view.isUserInteractionEnabled = true
      view.addGestureRecognizer(labelTap)
   }

   @objc func labelTapped(_ sender: UITapGestureRecognizer) {
      send(\.didTap)
   }
}

extension LabelModel: Stateable2 {
   typealias State = LabelState
   typealias State2 = ViewState
}

class CustomTap: UITapGestureRecognizer {
   var user1: String?
   var user2: String?
}
