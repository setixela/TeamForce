//
//  TransactScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 18.08.2022.
//
import ReactiveWorks
import UIKit

// MARK: - View models

final class TransactViewModels<Asset: AssetProtocol>: Assetable {
   //
   lazy var digitalThanksTitle = Design.label.headline4
      .set_text(Text.title.digitalThanks)
      .set_numberOfLines(1)
      .set_alignment(.left)
      .set_padding(.init(top: 22, left: 0, bottom: 26, right: 0))

   lazy var userSearchTextField = TextFieldModel<Design>()
      .set_backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08))
      .set_height(48)
      .set_placeholder(Text.title.chooseRecipient)
      .set_hidden(true)
      .set_padding(.init(top: 0, left: 16, bottom: 0, right: 16))

   lazy var transactInputViewModel = TransactInputViewModel<Design>()
      .set(.leftCaptionText(Text.title.sendThanks))
      .set(.rightCaptionText(Text.title.availableThanks))
      .set_hidden(true)

   lazy var tableModel = TableViewModel()
      .set_borderColor(.gray)
      .set_borderWidth(1)
      .set_cornerRadius(Design.params.cornerRadius)
      .set_hidden(true)

   lazy var sendButton = Design.button.default
      .set(Design.state.button.inactive)
      .set_title(Text.button.sendButton)
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
   
   lazy var transactionStatusView = TransactionStatusViewModel<Asset>()
}
