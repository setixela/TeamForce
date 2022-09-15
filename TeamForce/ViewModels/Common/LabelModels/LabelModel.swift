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

   func makePartsClickable(user1: String?, user2: String?) {
      view.isUserInteractionEnabled = true
      view.lineBreakMode = .byWordWrapping
      let tapGesture = CustomTap(target: self, action: #selector(tappedOnLabel(_:)))
      tapGesture.user1 = user1
      tapGesture.user2 = user2
      tapGesture.numberOfTouchesRequired = 1
      view.addGestureRecognizer(tapGesture)
   }

   @objc func tappedOnLabel(_ gesture: CustomTap) {
      print("I am in tapped on label")
      guard let text = view.text else { return }
      
      let firstRange = (text as NSString).range(of: gesture.user1.string)
      let secondRange = (text as NSString).range(of: gesture.user2.string)
      if gesture.didTapAttributedTextInLabel(label: view, inRange: firstRange) {
         print("firstRange tapped")
      } else if gesture.didTapAttributedTextInLabel(label: view, inRange: secondRange) {
         print("secondRange tapped")
      }
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
