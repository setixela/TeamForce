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
   DoubleStacksModel,
   Asset,
   Transaction
> {
   private lazy var input: Transaction? = nil
   typealias State = StackState

   private lazy var transactionOwnerLabel = LabelModel()
      .set(.numberOfLines(0))
//   private lazy var statusLabel = LabelModel()
   private lazy var dateLabel = LabelModel()
      .set(.textColor(UIColor.gray))
   private lazy var amountLabel = LabelModel()
//      .set(Design.state.label.headline3)
  

   private lazy var firstStack = StackModel()
      .set(.distribution(.equalCentering))
      .set(.alignment(.center))
      .set(.spacing(8))
      .set(.models([
         dateLabel,
         transactionOwnerLabel,
         amountLabel,
         //statusLabel,
         currencyLabel
      ]))
   
   lazy var reasonLabel = SettingsTitleBodyDT<Design>()
      .setAll {
         $0.text("Cообщение")
         $1.text("-")
      }
   
   lazy var statusLabel = SettingsTitleBodyDT<Design>()
      .setAll {
         $0.text("Статус перевода")
         $1.text("-")
      }
   
   lazy var infoStack = UserProfileStack<Design>()
      .arrangedModels([
         LabelModel()
            .text("ИНФОРМАЦИЯ")
            .set(Design.state.label.caption2),
         reasonLabel,
         statusLabel,
      ])
      .distribution(.fill)
      .alignment(.fill)


   
   private lazy var currencyLabel = CurrencyLabelDT<Design>()
      .setAll {
         $0
            .height(Grid.x32.value)
            .set(Design.state.label.headline4)
            .textColor(Design.color.success)
         $1
            .width(Grid.x26.value)
            .height(Grid.x26.value)
            .imageTintColor(Design.color.success)
      }

   private lazy var fourthStack = StackModel()
      .set(.padding(.init(top: 16, left: 16, bottom: 16, right: 16)))
      .set(.cornerRadius(20))
      .set(.backColor(.white))
      .set(.axis(.vertical))
      .set(.distribution(.fill))
      .set(.alignment(.center))
      .set(.models([
         firstStack,
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
      .image(Design.icon.avatarPlaceholder)
      .contentMode(.scaleAspectFill)
      .cornerRadius(70 / 2)
      .size(.square(70))
      .shadow(Design.params.cellShadow)
   )
   

   private func configure() {
     
      mainVM.topStackModel
         .set(Design.state.stack.default)
         .alignment(.center)
         .set(.backColor(Design.color.backgroundSecondary))
         .arrangedModels([
            //
            Grid.x64.spacer,
            image,
            Grid.x32.spacer,
            fourthStack,
            Grid.x64.spacer,
         ])

      mainVM.bottomStackModel
         .set(Design.state.stack.bottomPanel)
         .arrangedModels([
            infoStack,
            Grid.xxx.spacer,
         ])
   }

   private func configureLabels(wS: TransactDeatilViewModel<Asset>?) {
      guard let input = wS?.inputValue else { return }
      wS?.input = input

      print("detail input \(input)")
      switch input.sender?.senderTgName == currentUser {
      case true:
         transactionOwnerLabel
            .set(.text("Вы отправили @" + (input.recipient?.recipientTgName ?? "")))
         amountLabel
            .set(.text((input.amount ?? "") + " спасибок"))
         currencyLabel.label
            .text("-" + (input.amount ?? ""))
         if let urlSuffix = input.recipient?.recipientPhoto {
            let urlString = TeamForceEndpoints.urlBase + urlSuffix
            image.subModel.url(urlString)
         } else {
            var userIconText = ""
            if let nameFirstLetter = input.recipient?.recipientFirstName?.first,
               let surnameFirstLetter = input.recipient?.recipientSurname?.first {
               userIconText = String(nameFirstLetter) + String(surnameFirstLetter)
            }
            let tempImage = userIconText.drawImage(backColor: Design.color.backgroundBrand)
            image.subModel
               .image(tempImage)
               .backColor(Design.color.backgroundBrand)
         }
      case false:
         transactionOwnerLabel
            .set(.text("Вы получили от @" + (input.sender?.senderTgName ?? "")))
         amountLabel
            .set(.text((input.amount ?? "") + " спасибок"))
         currencyLabel.label
            .text("+" + (input.amount ?? ""))
         if let urlSuffix = input.sender?.senderPhoto {
            let urlString = TeamForceEndpoints.urlBase + urlSuffix
            image.subModel.url(urlString)
         } else {
            var userIconText = ""
            if let nameFirstLetter = input.sender?.senderFirstName?.first,
               let surnameFirstLetter = input.sender?.senderSurname?.first {
               userIconText = String(nameFirstLetter) + String(surnameFirstLetter)
            }
            let tempImage = userIconText.drawImage(backColor: Design.color.backgroundBrand)
            image.subModel
               .image(tempImage)
               .backColor(Design.color.backgroundBrand)
         }
      }

      var textColor = UIColor.black
      switch input.transactionStatus?.id {
      case "A":
         textColor = UIColor.systemGreen
      case "D":
         textColor = Design.color.boundaryError
         statusLabel.models.main.text("Причина отказа")
      case "W":
         textColor = UIColor.orange
      default:
         textColor = UIColor.black
      }
      statusLabel.models.down.set(.textColor(textColor))
      amountLabel.set(.textColor(textColor))

      statusLabel.models.down.text(input.transactionStatus?.name ?? "")
      reasonLabel.models.down.text(input.reason ?? "")

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
