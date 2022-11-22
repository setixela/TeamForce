//
//  TransactDetailViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 10.08.2022.
//

import ReactiveWorks
import UIKit

final class SentTransactDetailsScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   ModalDoubleStackModel<Asset>,
   Asset,
   Transaction
> {
   typealias State = StackState

   private lazy var transactionOwnerLabel = LabelModel()
      .set(.numberOfLines(0))
      .set(.alignment(.center))
   
   //   private lazy var statusLabel = LabelModel()
   private lazy var dateLabel = LabelModel()
      .set(.textColor(UIColor.gray))
   private lazy var amountLabel = LabelModel()
   //      .set(Design.state.label.headline3)

   private lazy var firstStack = StackModel()
      .set(.distribution(.equalCentering))
      .set(.alignment(.center))
      .set(.spacing(8))
      .set(.arrangedModels([
         dateLabel,
         transactionOwnerLabel,
         amountLabel,
         // statusLabel,
         currencyLabel,
      ]))

   private lazy var reasonLabel = SettingsTitleBodyDT<Design>()
      .setAll {
         $0
            .text("Cообщение")
            .set(Design.state.label.body4)
         $1
            .text("-")
            .set(Design.state.label.caption)
      }

   private lazy var statusLabel = SettingsTitleBodyDT<Design>()
      .setAll {
         $0
            .text("Статус благодарности")
            .set(Design.state.label.body4)
         $1
            .text("-")
            .set(Design.state.label.caption)
      }

   lazy var transactPhoto = Combos<SComboMD<LabelModel, ImageViewModel>>()
      .setAll {
         $0
            .padBottom(10)
            .set(Design.state.label.body4)
            .text("Фотография")
         $1
            .image(Design.icon.transactSuccess)
            .height(130)
            .width(130)
            .contentMode(.scaleAspectFill)
            .cornerRadius(Design.params.cornerRadiusSmall)
      }
      .hidden(true)

   lazy var infoStack = UserProfileStack<Design>()
      .arrangedModels([
         LabelModel()
            .text("ИНФОРМАЦИЯ")
            .set(Design.state.label.captionSecondary),
         reasonLabel,
         statusLabel,
         transactPhoto,
         Grid.xxx.spacer,
      ])
      .distribution(.fill)
      .alignment(.leading)

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
      .set(.arrangedModels([
         firstStack,
      ]))
   
   private lazy var hashTagBlock = HashTagsScrollModel<Design>()
      .hidden(true)

   private lazy var apiUseCase = Asset.apiUseCase
   private lazy var storageUseCase = Asset.storageUseCase
  // private lazy var currentUser: String = ""
   private var currentUserId: Int?

   private lazy var image = WrappedY(ImageViewModel()
      .image(Design.icon.newAvatar)
      .contentMode(.scaleAspectFill)
      .cornerRadius(70 / 2)
      .size(.square(70))
      .shadow(Design.params.cellShadow)
   )

   override func start() {
      weak var wS = self

      configure()

      storageUseCase.getCurrentUserName
         .doAsync()
         .onSuccess {
            //Self.store.currentUserName = $0
         }
         .doNext(self.storageUseCase.getCurrentUserId)
         .onSuccess {
            self.currentUserId = Int($0)
         }
      
      apiUseCase.loadProfile
         .doAsync()
         .onSuccess { user in
            //wS?.currentUser = user.profile.tgName
            wS?.configureLabels(wS: wS)
         }
         .onFail {
            print("profile not loaded")
         }

      mainVM.closeButton.on(\.didTap, self) {
         $0.dismiss()
      }
   }
}

// MARK: - Private funcs

extension SentTransactDetailsScene {
   private func configure() {
      mainVM.bodyStack
         .alignment(.center)
         .set(.backColor(Design.color.backgroundSecondary))
         .arrangedModels([
            //
            Spacer(32),
            Spacer(maxSize: 32),
            image,
            Spacer(maxSize: 32),
            fourthStack,
            Spacer(maxSize: 64),
         ])

      mainVM.footerStack
         .arrangedModels([
            hashTagBlock,
            Spacer(12),
            infoStack,
         ])
   }

   private func configureTags(tags: [FeedTag]?) {
      if tags?.isEmpty == false {
         hashTagBlock.setup(tags)
         hashTagBlock.hidden(false)
      }
   }
   
   private func configureLabelForTransact(input: Transaction) {
      switch input.sender?.senderId == currentUserId {
      case true:
         currencyLabel.models.main.textColor(Design.color.textError)
         currencyLabel.models.right.imageTintColor(Design.color.textError)
         transactionOwnerLabel
            .set(.text("Вы отправили @" + (input.recipient?.recipientTgName ?? "")))
         amountLabel
            .set(.text((input.amount ?? "") + " спасибок"))

         if let urlSuffix = input.recipient?.recipientPhoto {
            let urlString = TeamForceEndpoints.urlBase + urlSuffix
            image.subModel.url(urlString)
         } else {
            var userIconText = ""
            if let nameFirstLetter = input.recipient?.recipientFirstName?.first,
               let surnameFirstLetter = input.recipient?.recipientSurname?.first
            {
               userIconText = String(nameFirstLetter) + String(surnameFirstLetter)
            }
            let tempImage = userIconText.drawImage(backColor: Design.color.backgroundBrand)
            image.subModel
               .image(tempImage)
               .backColor(Design.color.backgroundBrand)
         }
         
         if let challName = input.sender?.challengeName {
            transactionOwnerLabel
               .set(.text("Вы отправили для взноса в челлендж " + challName))
            image.subModel.image(Design.icon.challengeAvatar)
         }
      case false:
         transactionOwnerLabel
            .set(.text("Вы получили от @" + (input.sender?.senderTgName ?? "")))
         amountLabel
            .set(.text((input.amount ?? "") + " спасибок"))
         if let urlSuffix = input.sender?.senderPhoto {
            let urlString = TeamForceEndpoints.urlBase + urlSuffix
            image.subModel.url(urlString)
         } else {
            var userIconText = ""
            if let nameFirstLetter = input.sender?.senderFirstName?.first,
               let surnameFirstLetter = input.sender?.senderSurname?.first
            {
               userIconText = String(nameFirstLetter) + String(surnameFirstLetter)
            }
            let tempImage = userIconText.drawImage(backColor: Design.color.backgroundBrand)
            image.subModel
               .image(tempImage)
               .backColor(Design.color.backgroundBrand)
         }
         statusLabel
            .models.main.text("Тип благодарности")
         statusLabel
            .models.down.text("Входящая благодарность")
      }

      var textColor = UIColor.black
      switch input.transactionStatus?.id {
      case "A":
         textColor = UIColor.systemGreen
      case "D":
         textColor = Design.color.boundaryError
         statusLabel.models.main.text("Причина отказа")
         transactionOwnerLabel.text("Вы хотели отправили @" + (input.recipient?.recipientTgName ?? ""))
      case "W":
         textColor = UIColor.orange
      default:
         textColor = UIColor.black
      }
      statusLabel.models.down.set(.textColor(textColor))
      amountLabel.set(.textColor(textColor))

      statusLabel.models.down.text(input.transactionStatus?.name ?? "")
      reasonLabel.models.down.text(input.reason ?? "")
   }
   
   private func configureLabels(wS: SentTransactDetailsScene<Asset>?) {
      guard let input = wS?.inputValue else { return }
      
      currencyLabel.label
         .text(input.amount ?? "")
      
      configureTags(tags: input.tags)
      configureLabelForTransact(input: input)

      if let photoLink = input.photo {
         transactPhoto.models.down.url(TeamForceEndpoints.convertToImageUrl(photoLink))
         transactPhoto.models.down.view.on(\.didTap, self) {
            $0.dismiss()
            Asset.router?.route(
               .presentModally(.automatic),
               scene: \.imageViewer,
               payload: TeamForceEndpoints.convertToFullImageUrl(photoLink)
            ) { [weak self] _ in
               Asset.router?.route(.presentModally(.automatic), scene: \.sentTransactDetails, payload: self?.inputValue)
            }
         }
         transactPhoto.hidden(false)
      }

      guard let convertedDate = (input.createdAt ?? "").convertToDate() else { return }

      dateLabel
         .set(.text(convertedDate))
   }
}
