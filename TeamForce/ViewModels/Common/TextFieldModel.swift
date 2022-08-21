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
   var didBeginEditing: Event<String>?
}

final class TextFieldModel<Design: DSP>: BaseViewModel<PaddingTextField>,
   Designable,
   Stateable2,
   UITextFieldDelegate
{
   var events: TextFieldEvents = .init()

   override func start() {
      set(.backColor(.lightGray.withAlphaComponent(0.3)))
      set(.clearButtonMode(.whileEditing))
      set(.cornerRadius(Design.params.cornerRadius))
      view.delegate = self
      view.addTarget(self, action: #selector(changValue), for: .editingChanged)
      view.addTarget(self, action: #selector(didEditingBegin), for: .editingDidBegin)
   }

   @objc func changValue() {
      guard let text = view.text else { return }

      sendEvent(\.didEditingChanged, text)
   }

   @objc func didEditingBegin() {
      guard let text = view.text else { return }
      sendEvent(\.didBeginEditing, text)
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
