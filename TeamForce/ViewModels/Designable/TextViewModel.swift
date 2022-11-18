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
