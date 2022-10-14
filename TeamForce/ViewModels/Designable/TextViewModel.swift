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
   var didEditingChanged: String?
}

class TextViewModel: BaseViewModel<UITextView>, UITextViewDelegate {

   var events: EventsStore = .init()

   private var placeholder: String = ""
   private var isPlaceholded = true

   override func start() {
      view.delegate = self
      view.textColor = UIColor.lightGray
   }

   @objc func changValue() {
      guard let text = view.text else { return }

      send(\.didEditingChanged, text)
   }

   func textViewDidChange(_ textView: UITextView) {
      send(\.didEditingChanged, textView.text)
   }

   func textViewDidBeginEditing(_ textView: UITextView) {

      if textView.text == placeholder {
         textView.text = nil
         textView.textColor = UIColor.black
         isPlaceholded = false
      }
   }

   func textViewDidEndEditing(_ textView: UITextView) {
      if textView.text == nil || textView.text.isEmpty {
         textView.text = self.placeholder
         textView.textColor = UIColor.lightGray
         isPlaceholded = true
      }
   }

   @discardableResult func placeholder(_ value: String) -> Self {
      set(.placeholder(value))
      textViewDidEndEditing(view)
      return self
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

extension TextViewModel: Stateable3 {
   typealias State = ViewState
   typealias State2 = TextViewState
   typealias State3 = LabelState

   func applyState(_ state: TextViewState) {
      switch state {
      case .text(let string):
         text(string)
      case .placeholder(let string):
         self.placeholder = string
         text(string)
      case .font(let value):
         font(value)
      case .padding(let value):
         padding(value)
      case .height(let value):
         height(value)
      case .width(let value):
         width(value)
      }
   }
}

extension TextViewModel: Eventable {
   typealias Events = TextViewEvents
}
