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

final class TextFieldModel: BaseViewModel<PaddingTextField>,
   Stateable2,
   UITextFieldDelegate
{
   var events: TextFieldEvents = .init()

   override func start() {
      set(.backColor(.lightGray.withAlphaComponent(0.3)))
      set(.clearButtonMode(.whileEditing))
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

   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      guard view.isOnlyDigitsMode else { return false }

      let allowedCharacters = CharacterSet.decimalDigits
      let characterSet = CharacterSet(charactersIn: string)
      return allowedCharacters.isSuperset(of: characterSet)
   }
}

extension TextFieldModel {
   typealias State = TextFieldState
   typealias State2 = ViewState
}

extension TextFieldModel: Communicable {}
