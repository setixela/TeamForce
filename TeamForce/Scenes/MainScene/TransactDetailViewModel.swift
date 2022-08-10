//
//  TransactDetailViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 10.08.2022.
//

import ReactiveWorks
import UIKit

final class TransactDeatilViewModel<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   StackWithBottomPanelModel,
   Asset,
   Transaction
> {
    private lazy var input: Transaction? = nil
    private lazy var senderLabel = LabelModel()
    private lazy var recipientLabel = LabelModel()
    private lazy var amountLabel = LabelModel()
    
        .set(.text("Hello"))
   // MARK: - Services
    
   override func start() {
      configure()
      print("inputValue")
      weak var wS = self
      guard let input = wS?.inputValue else { return }
      wS?.input = input
      guard let input = wS?.input else { return }
      amountLabel
          .set(.text(input.amount))
      senderLabel
          .set(.text(input.sender.senderTgName))
      recipientLabel
          .set(.text(input.recipient.recipientTgName))
       
    }

   private func configure() {
      mainViewModel
         .set(Design.State.mainView.default)
         .set(.backColor(Design.color.background2))

      mainViewModel
         .set(.models([
            senderLabel,
            recipientLabel,
            amountLabel,
            Spacer(16),
            Spacer()
         ]))
   }
}
