//
//  TransactInputViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 29.07.2022.
//

import ReactiveWorks
import UIKit

enum TransactInputState {
   case noInput
   case normal(String? = nil)
   case error
}

final class TransactInputViewModel<Design: DesignProtocol>: BaseViewModel<StackViewExtended>,
   Designable, Stateable
{
   typealias State = StackState

   lazy var textField = TextFieldModel()
      .set_keyboardType(.numberPad)
      .set_onlyDigitsMode()
      .set(.clearButtonMode(.never))
      .set(Design.state.label.headline2)
      .set(.height(72))
      .set(.placeholder("0"))
      .set_placeholderColor(Design.color.textSecondary)
      .set(.padding(.init(top: 0, left: 0, bottom: 0, right: 0)))
      .set(.backColor(Design.color.backgroundSecondary))

   // MARK: - Private

   private lazy var wrapper = StackModel()
      .set_axis(.horizontal)
      .set_alignment(.center)
      .set_arrangedModels([
         textField,
         currencyIcon
      ])

   private lazy var currencyIcon = ImageViewModel()
      .set_image(Design.icon.logoCurrencyBig)
      .set_size(.init(width: 36, height: 36))
      .set_contentMode(.scaleAspectFit)

   private lazy var currencyButtons = [
      CurrencyButtonDT<Design>.makeWithValue(1),
      CurrencyButtonDT<Design>.makeWithValue(5),
      CurrencyButtonDT<Design>.makeWithValue(10),
      CurrencyButtonDT<Design>.makeWithValue(25)
   ]

   private lazy var currencyButtonsStack = StackModel()
      .set_axis(.horizontal)
      .set_spacing(Grid.x16.value)
      .set_arrangedModels(currencyButtons)
      .set_padding(.verticalOffset(Grid.x24.value))

   private var defaultValues: [String] = []

   // MARK: - Implements

   override func start() {
      set_padding(.top(Grid.x8.value))
      set_alignment(.fill)
      set_distribution(.fill)
      set_axis(.vertical)
      set_spacing(0)
      set_arrangedModels([
         StackModel(
            wrapper,
            ViewModel()
               .set_height(Design.params.borderWidth)
               .set_backColor(Design.color.iconSecondary)
         ),
         currencyButtonsStack
      ])
      set_backColor(Design.color.backgroundSecondary)

      setState(.noInput)

      setupButtons()
   }
}

// MARK: - State Machine

extension TransactInputViewModel: StateMachine {
   func setState(_ state: TransactInputState) {
      deselectAllButtons()
      switch state {
      case .noInput:
         textField.set_textColor(Design.color.textSecondary)
         currencyIcon.set_imageTintColor(Design.color.textSecondary)
      case .normal(let text):
         defaultValues.enumerated().forEach {
            if $0.element == text {
               currencyButtons[$0.offset].setMode(\.selected)
            } else {
               currencyButtons[$0.offset].setMode(\.normal)
            }
         }
         textField.set_textColor(Design.color.text)
         currencyIcon.set_imageTintColor(Design.color.text)
      case .error:
         currencyIcon.set_imageTintColor(Design.color.textError)
         textField.set_textColor(Design.color.textError)
      }

   }
}

// MARK: - Default money buttons

private extension TransactInputViewModel {
   func setupButtons() {
      currencyButtons.enumerated().forEach { [weak self] index, button in
         defaultValues.append((button.currencyValue.toString))

         button
            .onEvent(\.didTap) {
           //    self?.textField.set_text("\(button.currencyValue)")
             // self?.setState(.normal())
               button.setMode(\.selected)
               self?.textField.sendEvent(\.didEditingChanged, "\(button.currencyValue)")
            }
      }
   }

   func deselectAllButtons() {
      currencyButtons.forEach {
         $0.setMode(\.normal)
      }
   }
}

extension Equatable {
   var toString: String {
      "\(self)"
   }
}
