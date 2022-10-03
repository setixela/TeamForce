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
   var didEditingChanged: String?
   var didTap: String?
   var didBeginEditing: String?
   var didEndEditing: String?
}

class TextFieldModel: BaseViewModel<PaddingTextField>,
   Stateable3,
   Eventable,
   UITextFieldDelegate
{
   typealias Events = TextFieldEvents

   var events = [Int: LambdaProtocol?]()

   override func start() {
      set(.clearButtonMode(.whileEditing))
      view.delegate = self
      view.addTarget(self, action: #selector(changValue), for: .editingChanged)
      view.addTarget(self, action: #selector(didEditingBegin), for: .editingDidBegin)
      view.addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
   }

   @objc func changValue() {
      guard let text = view.text else { return }

      send(\.didEditingChanged, text)
   }

   @objc func didEditingBegin() {
      guard let text = view.text else { return }
      send(\.didBeginEditing, text)
      print("Did tap textfield")
   }

   @objc func didEndEditing() {
      send(\.didEndEditing, view.text.string)
   }

   func textFieldDidBeginEditing(_ textField: UITextField) {
      // view.becomeFirstResponder()
   }

   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      guard view.isOnlyDigitsMode else { return true }

      let allowedCharacters = CharacterSet.decimalDigits
      let characterSet = CharacterSet(charactersIn: string)
      return allowedCharacters.isSuperset(of: characterSet)
   }
}

extension TextFieldModel {
   typealias State = TextFieldState
   typealias State2 = ViewState
   typealias State3 = LabelState
}

