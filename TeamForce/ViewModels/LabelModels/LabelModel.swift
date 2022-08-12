//
//  LabelModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.06.2022.
//

import ReactiveWorks
import UIKit

struct LabelModelEvents: InitProtocol {
   var didTap: Event<Void>?
}

final class LabelModel: BaseViewModel<PaddingLabel>, Communicable {
   var eventsStore: ButtonEvents = .init()
   
   func makeTappable() {
      let labelTap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
      view.isUserInteractionEnabled = true
      view.addGestureRecognizer(labelTap)
   }
   
   @objc func labelTapped(_ sender: UITapGestureRecognizer) {
      sendEvent(\.didTap)
   }
}

extension LabelModel: Stateable2 {
   typealias State = LabelState
   typealias State2 = ViewState
}
