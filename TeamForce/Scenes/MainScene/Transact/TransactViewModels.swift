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

   lazy var balanceInfo = Combos<SComboMDR<LabelModel, LabelModel, ImageViewModel>>()
      .setAll { title, subtitle, currencyIcon in
         title
            .set_font(Design.font.caption)
            .set_text("Доступно")
            .set_color(Design.color.iconInvert)
         subtitle
            .set_font(Design.font.title2)
            .set_text("0")
            .set_color(Design.color.iconInvert)
            .set_height(Grid.x20.value)
         currencyIcon
            .set_image(Design.icon.logoCurrency)
            .set_width(Grid.x20.value)
            .set_imageTintColor(Design.color.iconInvert)
      }
      .set_alignment(.leading)
      .set_height(Grid.x90.value)
      .set_backColor(Design.color.iconContrast)
      .set_cornerRadius(Design.params.cornerRadius)
      .set_padding(Design.params.infoFramePadding)

   lazy var userSearchTextField = TextFieldModel<Design>()
      .set(Design.state.textField.default)
      .set_placeholder(Design.Text.title.chooseRecipient)
      .set_hidden(true)

   lazy var transactInputViewModel = TransactInputViewModel<Design>()
      .set_hidden(true)
      .set_alignment(.center)

   lazy var tableModel = TableViewModel()
      .set_borderColor(.gray)
      .set_borderWidth(1)
      .set_cornerRadius(Design.params.cornerRadius)
      .set_hidden(true)

   lazy var sendButton = Design.button.default
      .set(Design.state.button.inactive)
      .set_title(Design.Text.button.sendButton)
      .set_hidden(true)

   lazy var reasonTextView = TextViewModel<Design>()
      .set(.padding(.init(top: 16, left: 16, bottom: 16, right: 16)))
      .set(.placeholder(TextBuilder.title.reasonPlaceholder))
      .set(.font(Design.font.body1))
      .set_backColor(UIColor.clear)
      .set_borderColor(.lightGray.withAlphaComponent(0.4))
      .set_borderWidth(1.0)
      .set_height(200)
      .set_hidden(true)

   lazy var transactionStatusView = TransactionStatusViewModel<Design>()
}
