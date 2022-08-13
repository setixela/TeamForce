//
//  TextFieldModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import Anchorage
import ReactiveWorks
import UIKit

struct TextFieldEvents: InitProtocol {
   var didEditingChanged: Event<String>?
   var didTap: Event<String>?
}

final class TextFieldModel<Design: DSP>: BaseViewModel<PaddingTextField>,
   Designable,
   Stateable2,
   UITextFieldDelegate
{
   var eventsStore: TextFieldEvents = .init()

   override func start() {
      set(.backColor(.lightGray.withAlphaComponent(0.3)))
      set(.clearButtonMode(.whileEditing))
      set(.cornerRadius(Design.params.cornerRadius))
      view.delegate = self
      view.addTarget(self, action: #selector(changValue), for: .editingChanged)
      view.addTarget(self, action: #selector(didTap), for: .touchDown)
   }

   @objc func changValue() {
      guard let text = view.text else { return }

      sendEvent(\.didEditingChanged, text)
   }

   @objc func didTap() {
      guard let text = view.text else { return }
      sendEvent(\.didTap, text)
      print("Did tap textfield")
   }

   func textFieldDidBeginEditing(_ textField: UITextField) {
      // view.becomeFirstResponder()
   }
}

extension TextFieldModel {
   typealias State = TextFieldState
   typealias State2 = ViewState
}

extension TextFieldModel: Communicable {}
