//
//  TextFieldModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import Anchorage
import ReactiveWorks
import UIKit

// MARK: - TextFieldModel

enum TextFieldState {
   case text(String)
   case placeholder(String)
   case font(UIFont)
   case clearButtonMode(UITextField.ViewMode)
   case padding(UIEdgeInsets)
   case height(CGFloat)
   case widht(CGFloat)
}

struct TextFieldEvents: InitProtocol {
   var didEditingChanged: Event<String>?
   var didTap: Event<String>?
}

final class TextFieldModel: BaseViewModel<PaddingTextField> {
   var eventsStore: TextFieldEvents = .init()

   override func start() {
      set(.backColor(.lightGray.withAlphaComponent(0.3)))
      set(.clearButtonMode(.whileEditing))
      set(.cornerRadius(GlobalParameters.cornerRadius))
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
}

extension TextFieldModel: Stateable2 {
   typealias State = ViewState

   func applyState(_ state: TextFieldState) {
      switch state {
      case .text(let string):
         view.text = string
      case .placeholder(let string):
         view.placeholder = string
      case .font(let font):
         view.font = font
      case .clearButtonMode(let value):
         view.clearButtonMode = value
      case .padding(let value):
         view.padding = value
      case .height(let value):
         view.addAnchors.constHeight(value)
      case .widht(let value):
         view.addAnchors.constWidth(value)
      }
   }
}

extension TextFieldModel: UITextFieldDelegate {
   func textFieldDidBeginEditing(_ textField: UITextField) {
      // view.becomeFirstResponder()
   }
}

extension TextFieldModel: Communicable {}

// MARK: - TelegramNickCheckerModel

final class TelegramNickCheckerModel {}

extension TelegramNickCheckerModel: WorkerProtocol {
   func doAsync(work: Work<String, String>) {
      if work.unsafeInput.count > 3 {
         work.success(result: work.unsafeInput)
      } else {
         work.fail( work.unsafeInput)
      }
   }
}

// MARK: - SmsCodeCheckerModel

final class SmsCodeCheckerModel {
   private var maxDigits: Int = 4

   convenience init(maxDigits: Int) {
      self.init()
      self.maxDigits = maxDigits
   }
}

extension SmsCodeCheckerModel: WorkerProtocol {
   //
   func doAsync(work: Work<String, String>) {
      let text =  work.unsafeInput

      if work.unsafeInput.count >= maxDigits {
         let text = text.dropLast(text.count - maxDigits)
         work.success(result: String(text))
      } else {
         work.fail(text)
      }
   }
}

// MARK: - CoinInputCheckerModel

final class CoinInputCheckerModel {
   private var maxDigits: Int = 8

   convenience init(maxDigits: Int) {
      self.init()
      self.maxDigits = maxDigits
   }
}

extension CoinInputCheckerModel: WorkerProtocol {
   //
   func doAsync(work: Work<String, String>) {
      let text = work.unsafeInput

      if text.count > 0 {
         var textToSend = text
         if text.count >= maxDigits {
            textToSend = String(text.dropLast(text.count - maxDigits))
         }

         !text.isNumber ? work.fail(text) : work.success(result: textToSend)
      } else {
         work.fail(text)
      }
   }
}

// MARK: - ReasonCheckerModel

final class ReasonCheckerModel {
   private var maxDigits: Int = 8

   convenience init(maxDigits: Int) {
      self.init()
      self.maxDigits = maxDigits
   }
}

extension ReasonCheckerModel: WorkerProtocol {
   func doAsync(work: Work<String, String>) {
      let text = work.unsafeInput

      if text.count > 0 {
         work.success(result: text)
      } else {
         work.fail(text)
      }
   }
}

extension String {
   var isNumber: Bool {
      return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
   }
}
