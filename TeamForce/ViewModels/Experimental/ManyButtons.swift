//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 09.10.2022.
//

import ReactiveWorks

final class SlidedIndexButtons<ButtEvents: ManyButtonEvent>: BaseViewModel<UIScrollView>,
   IndexedButtonsProtocol,
   Stateable
{
   typealias Button = ModableButton

   //

   typealias State = ViewModel
   typealias Events = TapIndexEvents<ButtEvents>

   var events: EventsStore = .init()
   var buttons: [Button] = []
   private lazy var stack = StackModel()
      .axis(.horizontal)

   init(buttons: Button...) {
      super.init()

      guard buttons.isEmpty == false else { return }
      self.buttons = buttons
      configure()
   }

   private func configure() {
      buttons.first?.setMode(\.selected)
      buttons.enumerated().forEach { tuple in
         tuple.element
            .on(\.didTap, self) { slf in
               slf.buttons.forEach { but in but.setMode(\.normal) }
               tuple.element.setMode(\.selected)

               guard let eve = ButtEvents(rawValue: tuple.offset) else { return }

               slf.send(\.didTapButtons, eve)
            }
      }

      stack
         .spacing(Grid.x8.value)
         .alignment(.center)
         .arrangedModels(buttons)
      view.addSubview(stack.uiView)

      stack.view.addAnchors
         .top(view.topAnchor)
         .leading(view.leadingAnchor)
         .trailing(view.trailingAnchor)
         .height(view.heightAnchor)

      view.layer.masksToBounds = false
      view.clipsToBounds = false
      view.showsHorizontalScrollIndicator = false
   }

   required init() {
      fatalError("init() has not been implemented")
   }
}

struct TapIndexEvents<M: ManyButtonEvent>: InitProtocol {
   var didTapButtons: M?
}

// MARK: - Many Button events

protocol ManyButtonEvent: RawRepresentable where RawValue == Int {}

enum Button1Event: Int, ManyButtonEvent {
   case didTapButton1 = 0
}

enum Button2Event: Int, ManyButtonEvent {
   case didTapButton1 = 0
   case didTapButton2 = 1
}

enum Button3Event: Int, ManyButtonEvent {
   case didTapButton1 = 0
   case didTapButton2 = 1
   case didTapButton3 = 2
}

enum Button4Event: Int, ManyButtonEvent {
   case didTapButton1 = 0
   case didTapButton2 = 1
   case didTapButton3 = 2
   case didTapButton4 = 3
}

enum Button5Event: Int, ManyButtonEvent {
   case didTapButton1 = 0
   case didTapButton2 = 1
   case didTapButton3 = 2
   case didTapButton4 = 3
   case didTapButton5 = 4
}

enum Button6Event: Int, ManyButtonEvent {
   case didTapButton1 = 0
   case didTapButton2 = 1
   case didTapButton3 = 2
   case didTapButton4 = 3
   case didTapButton5 = 4
   case didTapButton6 = 5
}

protocol IndexedButtonsProtocol: Eventable where Events == TapIndexEvents<ButtEvents> {
   associatedtype Button: ModableButton
   associatedtype ButtEvents: ManyButtonEvent

   var buttons: [Button] { get }

   init(buttons: Button...)
}

import UIKit

extension IndexedButtonsProtocol {
   init(_ but1: Button) where Self.ButtEvents == Button1Event {
      self.init(buttons: but1)
   }

   init(_ but1: Button,
        _ but2: Button) where Self.ButtEvents == Button2Event
   {
      self.init(buttons: but1, but2)
   }

   init(_ but1: Button,
        _ but2: Button,
        _ but3: Button) where Self.ButtEvents == Button3Event
   {
      self.init(buttons: but1, but2, but3)
   }

   init(_ but1: Button,
        _ but2: Button,
        _ but3: Button,
        _ but4: Button) where Self.ButtEvents == Button4Event
   {
      self.init(buttons: but1, but2, but3, but4)
   }

   init(_ but1: Button,
        _ but2: Button,
        _ but3: Button,
        _ but4: Button,
        _ but5: Button) where Self.ButtEvents == Button5Event
   {
      self.init(buttons: but1, but2, but3, but4, but5)
   }

   init(_ but1: Button,
        _ but2: Button,
        _ but3: Button,
        _ but4: Button,
        _ but5: Button,
        _ but6: Button) where Self.ButtEvents == Button5Event
   {
      self.init(buttons: but1, but2, but3, but4, but5, but6)
   }
}

extension IndexedButtonsProtocol where ButtEvents == Button1Event {
   var button1: Button { buttons[0] }
}

extension IndexedButtonsProtocol where ButtEvents == Button2Event {
   var button1: Button { buttons[0] }
   var button2: Button { buttons[1] }
}

extension IndexedButtonsProtocol where ButtEvents == Button3Event {
   var button1: Button { buttons[0] }
   var button2: Button { buttons[1] }
   var button3: Button { buttons[2] }
}

extension IndexedButtonsProtocol where ButtEvents == Button4Event {
   var button1: Button { buttons[0] }
   var button2: Button { buttons[1] }
   var button3: Button { buttons[2] }
   var button4: Button { buttons[3] }
}

extension IndexedButtonsProtocol where ButtEvents == Button5Event {
   var button1: Button { buttons[0] }
   var button2: Button { buttons[1] }
   var button3: Button { buttons[2] }
   var button4: Button { buttons[3] }
   var button5: Button { buttons[4] }
}

extension IndexedButtonsProtocol where ButtEvents == Button6Event {
   var button1: Button { buttons[0] }
   var button2: Button { buttons[1] }
   var button3: Button { buttons[2] }
   var button4: Button { buttons[3] }
   var button5: Button { buttons[4] }
   var button6: Button { buttons[5] }
}
