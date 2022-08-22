//
//  TransactInputViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 29.07.2022.
//

import ReactiveWorks
import UIKit

enum TransactInputState {
   case leftCaptionText(String)
   case rightCaptionText(String)
}

final class TransactInputViewModel<Design: DesignProtocol>: BaseViewModel<StackViewExtended>,
   Designable, Stateable
{
   typealias State = StackState


   lazy var wrapper = StackModel()
      .set_axis(.horizontal)
      .set_alignment(.center)
      .set_arrangedModels([

         textField,
         ImageViewModel()
            .set_image(Design.icon.logoCurrencyBig)
            .set_size(.init(width: 36, height: 36))
            .set_contentMode(.scaleAspectFit),
      ])


   lazy var textField = TextFieldModel<Design>()
      .set(.clearButtonMode(.never))
      .set(.font(Design.font.headline2))
      .set(.height(72))
      .set(.placeholder("0"))
      .set(.padding(.init(top: 0, left: 0, bottom: 0, right: 0)))
      .set(.backColor(Design.color.backgroundSecondary))

   private lazy var currencyButtons = [
      CurrencyButtonDT<Design>.makeWithTitle("50"),
      CurrencyButtonDT<Design>.makeWithTitle("100"),
      CurrencyButtonDT<Design>.makeWithTitle("500")
   ]

   private lazy var currencyButtonsStack = StackModel()
      .set_axis(.horizontal)
      .set_spacing(Grid.x16.value)
      .set_arrangedModels(currencyButtons)

   override func start() {
      set(.alignment(.fill),
          .distribution(.fill),
          .axis(.vertical),
          .spacing(0),
        //  .height(118),
          .models([
             wrapper,// textField,
             currencyButtonsStack
          ]),
          .backColor(Design.color.backgroundSecondary)
      )
   }
}

extension CurrencyButtonDT {
   static func makeWithTitle(_ text: String) -> Self {
      let button = Self()
      button.models.main.set_text(text)
      return button
   }
}
