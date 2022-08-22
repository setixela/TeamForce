//
//  TransactScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 18.08.2022.
//
import ReactiveWorks
import UIKit

// MARK: - View models

final class TransactViewModels<Design: DSP>: Designable {
   //
   lazy var balanceInfo = Combos<SComboMD<LabelModel, CurrencyLabelDT<Design>>>()
      .setAll { title, _ in
         title
            .set_font(Design.font.caption)
            .set_text("Доступно")
            .set_color(Design.color.iconInvert)
      }
      .set_alignment(.leading)
      .set_height(Grid.x90.value)
      .set_backColor(Design.color.iconContrast)
      .set_cornerRadius(Design.params.cornerRadius)
      .set_padding(Design.params.infoFramePadding)

   lazy var userSearchTextField = TextFieldModel()
      .set(Design.state.textField.default)
      .set_placeholder(Design.Text.title.chooseRecipient)
      .set_hidden(true)

   lazy var transactInputViewModel = TransactInputViewModel<Design>()
      .set_hidden(true)
      .set_alignment(.center)

   lazy var tableModel = TableViewModel()
      .set_borderColor(.gray)
      .set_borderWidth(Design.params.borderWidth)
      .set_cornerRadius(Design.params.cornerRadius)
      .set_minHeight(300)
      .set_hidden(true)

   lazy var sendButton = Design.button.default
      .set(Design.state.button.inactive)
      .set_title(Design.Text.button.sendButton)
      .set_hidden(true)

   lazy var reasonTextView = TextViewModel()
      .set(.padding(Design.params.contentPadding))
      .set(.placeholder(TextBuilder.title.reasonPlaceholder))
      .set(.font(Design.font.body1))
      .set_backColor(Design.color.background)
      .set_borderColor(Design.color.boundary)
      .set_borderWidth(Design.params.borderWidth)
      .set_maxHeight(166)
      .set_hidden(true)

   lazy var addPhotoButton = ButtonModel()
      .set(Design.state.button)

   lazy var transactionStatusView = TransactionStatusViewModel<Design>()
}

final class TransactOptions<Design: DSP>: BaseViewModel<StackViewExtended>, Designable, Stateable {
   typealias State = StackState
   //
   private lazy var anonimParamModel = LabelSwitcherXDT<Design>.switcherWith(text: "Анонимно")
   private lazy var showEveryoneParamModel = LabelSwitcherXDT<Design>.switcherWith(text: "Показать всем")
   private lazy var addTagParamModel = LabelSwitcherXDT<Design>.switcherWith(text: "Добавить тег")

   private lazy var awaitOptionsModel = TitleBodySwitcherDT<Design>.switcherWith(titleText: "Период задержки",
                                                                      bodyText: "Без задержки")

   override func start() {
      set_arrangedModels([
         anonimParamModel,
         showEveryoneParamModel,
         addTagParamModel,
         awaitOptionsModel,
      ])
   }
}

final class LabelSwitcherXDT<Design: DSP>: LabelSwitcherX {
   override func start() {
      super.start()

      set_padding(Design.params.contentPadding)
   }
}

final class TitleBodySwitcherDT<Design: DSP>: TitleBodySwitcherY {
   override func start() {
      super.start()

      set_padding(Design.params.contentPadding)

      setAll { title, _ in
         title
            .set_color(Design.color.textSecondary)
            .set_font(Design.font.caption)
      }
   }
}

class LabelSwitcherX: Combos<SComboMR<LabelModel, WrappedY<Switcher>>> {
   var label: LabelModel { models.main }
   var switcher: Switcher { models.right.subModel }

   override func start() {
      set_alignment(.center)
      set_axis(.horizontal)

      setAll { _, _ in }
   }
}

class TitleBodySwitcherY: Combos<SComboMD<LabelModel, LabelSwitcherX>> {
   var title: LabelModel { models.main }
   var body: LabelModel { models.down.label }
   var switcher: Switcher { models.down.switcher }

   override func start() {
      set_axis(.vertical)

      setAll { _, _ in }
   }
}

extension TitleBodySwitcherY {
   static func switcherWith(titleText: String, bodyText: String) -> Self {
      Self()
         .setAll { title, bodySwitcher in
            title.set_text(titleText)
            bodySwitcher.label.set_text(bodyText)
         }
   }
}

extension LabelSwitcherX {
   static func switcherWith(text: String) -> Self {
      Self()
         .setAll { label, _ in
            label.set_text(text)
         }
   }
}

struct SwitchEvent: InitProtocol {
   var turnedOn: Event<Void>?
   var turnedOff: Event<Void>?
}

enum SwitcherState {
   case turnOn
   case turnOff
}

final class Switcher: BaseViewModel<UISwitch>, Communicable, Stateable2 {
   typealias State = ViewState
   typealias State2 = SwitcherState

   var events = SwitchEvent()

   override func start() {
      view.addTarget(self, action: #selector(didSwitch), for: .valueChanged)
   }

   @objc private func didSwitch() {
      if view.isOn {
         sendEvent(\.turnedOn)
      } else {
         sendEvent(\.turnedOff)
      }
   }
}

extension Switcher {
   func applyState(_ state: SwitcherState) {
      switch state {
      case .turnOn:
         view.setOn(true, animated: true)
      case .turnOff:
         view.setOn(false, animated: true)
      }
   }
}
