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
      .keyboardType(.numberPad)
      .onlyDigitsMode()
      .set(.clearButtonMode(.never))
      .set(Design.state.label.headline2)
      .set(.height(72))
      .set(.placeholder("0"))
      .placeholderColor(Design.color.textSecondary)
      .set(.padding(.init(top: 0, left: 0, bottom: 0, right: 0)))
      .set(.backColor(Design.color.backgroundSecondary))

   // MARK: - Private

   private lazy var wrapper = StackModel()
      .axis(.horizontal)
      .alignment(.center)
      .arrangedModels([
         textField,
         currencyIcon
      ])

   private lazy var currencyIcon = ImageViewModel()
      .image(Design.icon.logoCurrencyBig)
      .size(.init(width: 36, height: 36))
      .contentMode(.scaleAspectFit)

   private lazy var currencyButtons = [
      CurrencyButtonDT<Design>.makeWithValue(1),
      CurrencyButtonDT<Design>.makeWithValue(5),
      CurrencyButtonDT<Design>.makeWithValue(10),
      CurrencyButtonDT<Design>.makeWithValue(25)
   ]

   private lazy var currencyButtonsStack = StackModel()
      .axis(.horizontal)
      .spacing(Grid.x16.value)
      .arrangedModels(currencyButtons)
      .padding(.verticalOffset(Grid.x24.value))

   private var defaultValues: [String] = []

   // MARK: - Implements

   override func start() {

      padding(.top(Grid.x8.value))
      distribution(.fill)
      axis(.vertical)
      spacing(0)
      arrangedModels([
         StackModel(
            wrapper,
            ViewModel()
               .height(Design.params.borderWidth)
               .backColor(Design.color.iconSecondary)
         ),
         currencyButtonsStack
      ])
      backColor(Design.color.backgroundSecondary)

      setState(.noInput)
      alignment(.center)

      setupButtons()
   }
}

// MARK: - State Machine

extension TransactInputViewModel: StateMachine {
   func setState(_ state: TransactInputState) {
      deselectAllButtons()
      switch state {
      case .noInput:
         textField.textColor(Design.color.textSecondary)
         currencyIcon.imageTintColor(Design.color.textSecondary)
      case .normal(let text):
         defaultValues.enumerated().forEach {
            if $0.element == text {
               currencyButtons[$0.offset].setMode(\.selected)
            } else {
               currencyButtons[$0.offset].setMode(\.normal)
            }
         }
         textField.textColor(Design.color.text)
         currencyIcon.imageTintColor(Design.color.text)
      case .error:
         currencyIcon.imageTintColor(Design.color.textError)
         textField.textColor(Design.color.textError)
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
           //    self?.textField.text("\(button.currencyValue)")
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
