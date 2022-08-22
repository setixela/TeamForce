//
//  TextViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 29.07.2022.
//

import Anchorage
import ReactiveWorks
import UIKit

struct TextViewEvents: InitProtocol {
   var didEditingChanged: Event<String>?
}

final class TextViewModel: BaseViewModel<UITextView>, UITextViewDelegate {
   var events: TextViewEvents = .init()

   private var placeholder: String = "Placeholder"

   override func start() {
      view.delegate = self
   }

   @objc func changValue() {
      guard let text = view.text else { return }

      sendEvent(\.didEditingChanged, text)
   }

   func textViewDidChange(_ textView: UITextView) {
      sendEvent(\.didEditingChanged, textView.text)
   }

   func textViewDidBeginEditing(_ textView: UITextView) {
      if textView.textColor == UIColor.lightGray {
         textView.text = nil
         textView.textColor = UIColor.black
      }
   }

   func textViewDidEndEditing(_ textView: UITextView) {
      if textView.text.isEmpty {
         textView.text = self.placeholder
         textView.textColor = UIColor.lightGray
      }
   }
}

enum TextViewState {
   case text(String)
   case placeholder(String)
   case font(UIFont)
   case padding(UIEdgeInsets)
   case height(CGFloat)
   case width(CGFloat)
}

extension TextViewModel: Stateable2 {
   typealias State = ViewState

   func applyState(_ state: TextViewState) {
      switch state {
      case .text(let string):
         view.text = string
      case .placeholder(let string):
         self.placeholder = string
         view.text = self.placeholder
      case .font(let font):
         view.font = font
      case .padding(let value):
         view.textContainerInset = value
      case .height(let value):
         view.addAnchors.constHeight(value)
      case .width(let value):
         view.addAnchors.constWidth(value)
      }
   }
}

extension TextViewModel: Communicable {}
