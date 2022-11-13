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

final class TextViewExtended: UITextView, UITextViewDelegate {
   var events: EventsStore = .init()

   var placeholder: String? {
      didSet {
         text = placeholder
         setNeedsLayout()
      }
   }
   var placeHolderColor: UIColor = .gray

   private var baseTextColor: UIColor?
   private var isPlaceholded: Bool { text == placeholder }

   override init(frame: CGRect, textContainer: NSTextContainer?) {
      super.init(frame: frame, textContainer: textContainer)

      self.delegate = self
   }

   @available(*, unavailable)
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

   func textViewDidChange(_ textView: UITextView) {
      send(\.didEditingChanged, textView.text)
   }

   override func layoutSubviews() {
      super.layoutSubviews()

      if isPlaceholded {
         textColor = placeHolderColor
      } else {
         textColor = baseTextColor
      }
   }

   func textViewDidBeginEditing(_ textView: UITextView) {
      if isPlaceholded {
         text = nil
         textColor = baseTextColor
      }
   }

   func textViewDidEndEditing(_ textView: UITextView) {
      if textView.text == nil || textView.text.isEmpty {
         textView.text = placeholder
         textView.textColor = placeHolderColor
      }
   }
}

extension TextViewExtended: Eventable {
   typealias Events = TextViewEvents
}

class TextViewModel: BaseViewModel<TextViewExtended> {
   var events: EventsStore = .init()

   override func start() {
      view.on(\.didEditingChanged, self) {
         $0.send(\.didEditingChanged, $1)
      }
   }
}

enum TextViewState {
   case text(String)
   // case placeholder(String, UIColor)
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
//      case .placeholder(let string, let color):
//         self.placeholder = string
//         self.currentTextColor = color
//         text(string)
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
