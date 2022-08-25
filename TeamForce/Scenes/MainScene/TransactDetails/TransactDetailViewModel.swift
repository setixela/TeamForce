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
   StackModel,
   Asset,
   Transaction
> {
   private lazy var input: Transaction? = nil

   private lazy var transactionOwnerLabel = LabelModel()
      .set(.numberOfLines(0))
   private lazy var statusLabel = LabelModel()
   private lazy var dateLabel = LabelModel()
      .set(.color(UIColor.gray))
   private lazy var amountLabel = LabelModel()
      .set(.font(Design.font.headline3))
   private lazy var statusImage = ImageViewModel()
      .set(.size(.init(width: 48, height: 48)))
   private lazy var reasonLabel = LabelModel()
      .set(.numberOfLines(0))
      .set(.color(UIColor.gray))

   private lazy var firstStack = StackModel()
      .set(.distribution(.equalCentering))
      .set(.alignment(.leading))
      .set(.spacing(8))
      .set(.models([
         dateLabel,
         transactionOwnerLabel,
         statusLabel
      ]))

   private lazy var secondStack = StackModel()
      .set(.axis(.horizontal))
      .set(.distribution(.fillProportionally))
      .set(.alignment(.center))
      .set(.spacing(8))
      .set(.models([
         firstStack,
         statusImage
      ]))

   private lazy var thirdStack = StackModel()
      .set(.distribution(.fillProportionally))
      .set(.alignment(.leading))
      .set(.spacing(8))
      .set(.models([
         amountLabel,
         reasonLabel
      ]))

   private lazy var fourthStack = StackModel()
      .set(.padding(.init(top: 16, left: 16, bottom: 16, right: 16)))
      .set(.cornerRadius(20))
      .set(.backColor(.white))
      .set(.axis(.vertical))
      .set(.distribution(.fill))
      .set(.alignment(.fill))
      .set(.models([
         secondStack,
         Spacer(16),
         thirdStack
      ]))

   // MARK: - Services

   private lazy var apiUseCase = Asset.apiUseCase
   private lazy var currentUser: String = ""

   override func start() {
      weak var wS = self
      configure()
      apiUseCase.loadProfile
         .doAsync()
         .onSuccess { user in
            wS?.currentUser = user.profile.tgName
            wS?.configureLabels(wS: wS)
         }
         .onFail {
            print("profile not loaded")
         }
   }

   private lazy var image = WrappedY(ImageViewModel()
      .set_image(Design.icon.avatarPlaceholder)
      //.set_url(String.randomUrlImage)
      .set_size(.square(64))
   )
   .set_shadow(Design.params.cellShadow)
   .set_cornerRadius(64 / 2)

   private func configure() {
      mainVM
         .set_alignment(.center)
         .set_height(266)
         .set(Design.state.stack.default)
         .set(.backColor(Design.color.backgroundSecondary))

      mainVM
         .set(.models([
            Grid.x64.spacer,
            image,
            Grid.x32.spacer,
            fourthStack,
            Grid.x64.spacer,
            Spacer()
         ]))
   }

   private func configureLabels(wS: TransactDeatilViewModel<Asset>?) {
      guard let input = wS?.inputValue else { return }
      wS?.input = input

      switch input.sender?.senderTgName == currentUser {
      case true:
         transactionOwnerLabel
            .set(.text("Перевод для " + (input.recipient?.recipientTgName ?? "")))
         amountLabel
            .set(.text(input.amount ?? ""))
         statusImage
            .set(.image(Design.icon.sendCoinIcon))
      case false:
         transactionOwnerLabel
            .set(.text("Перевод от " + (input.sender?.senderTgName ?? "")))
         amountLabel
            .set(.text("+" + (input.amount ?? "")))
         statusImage
            .set(.image(Design.icon.recieveCoinIcon))
      }

      var textColor = UIColor.black
      switch input.transactionStatus?.id {
      case "A":
         textColor = UIColor.systemGreen
      case "D":
         textColor = Design.color.boundaryError
      case "W":
         textColor = UIColor.orange
      default:
         textColor = UIColor.black
      }
      statusLabel.set(.color(textColor))
      amountLabel.set(.color(textColor))

      statusLabel
         .set(.text(input.transactionStatus?.name ?? ""))
      reasonLabel
         .set(.text(input.reason ?? ""))
      
      if let urlSuffix = input.photo {
         let urlString = "http://176.99.6.251:8888" + urlSuffix
         image.subModel.set_url(urlString)
      }

      guard let convertedDate = (input.createdAt ?? "").convertToDate() else { return }
      dateLabel
         .set(.text(convertedDate))
   }
}

extension String {
   func convertToDate() -> String? {
      let inputFormatter = DateFormatter()
      inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      guard let convertedDate = inputFormatter.date(from: self) else { return nil }

      let outputFormatter = DateFormatter()
      outputFormatter.dateFormat = "d MMM y HH:mm"

      return outputFormatter.string(from: convertedDate)
   }
}
