//
//  Scenes.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.09.2022.
//

import ReactiveWorks

// MARK: - Transact models

protocol TransactModelBuilder: InitProtocol, Designable {
   //
   var balanceInfo: Combos<SComboMD<LabelModel, CurrencyLabelDT<Design>>> { get }
   var userSearchTextField: TextFieldModel { get }
   var reasonInputTextView: TextViewModel { get }
   var amountIputViewModel: TransactInputViewModel<Design> { get }
   var sendButton: ButtonModel { get }
   var addPhotoButton: ButtonModel { get }
   var foundUsersList: StackItemsModel { get }
   var pickedImagesPanel: PickedImagePanel<Design> { get }
//   var closeButton: ButtonModel { get }
   var userNotFoundInfoBlock: Wrapped2Y<ImageViewModel, LabelModel> { get }
   var transactOptionsBlock: TransactOptionsVM<Design> { get }
   var recipientCell: SendCoinRecipentCell<Design> { get }
   //
   var transactSuccessViewModel: TransactionStatusViewModel<Design> { get }
}

struct TransactBuilder<Design: DSP>: TransactModelBuilder {
   //
   var reasonInputTextView: TextViewModel { .init()
      .padding(Design.params.contentPadding)
      .placeholder(Design.Text.title.reasonPlaceholder)
      .set(Design.state.label.body1)
      .backColor(Design.color.background)
      .borderColor(Design.color.boundary)
      .borderWidth(Design.params.borderWidth)
      .cornerRadius(Design.params.cornerRadius)
      .minHeight(144)
      .hidden(true)
   }

   var userSearchTextField: TextFieldModel { .init()
      .set(Design.state.textField.default)
      .placeholder(Design.Text.title.chooseRecipient)
      .placeholderColor(Design.color.textFieldPlaceholder)
      .disableAutocorrection()
      .hidden(true)
   }

   var balanceInfo: M<LabelModel>.D<CurrencyLabelDT<Design>>.Combo { .init()
      .setAll { title, amount in
         title
            .set(Design.state.label.caption)
            .height(Grid.x20.value)
            .text("Доступно")
            .textColor(Design.color.iconInvert)
         amount.currencyLogo
            .width(Grid.x20.value)
      }
      .alignment(.leading)
      .height(Grid.x90.value)
      .backColor(Design.color.iconContrast)
      .cornerRadius(Design.params.cornerRadius)
      .padding(Design.params.infoFramePadding)
      .hidden(true)
   }

   var amountIputViewModel: TransactInputViewModel<Design> { .init()
      .hidden(true)
   }

   var sendButton: ButtonModel { .init()
      .set(Design.state.button.inactive)
      .title(Design.Text.button.sendButton)
   }

   var addPhotoButton: ButtonModel { .init()
      .title("Добавить фото")
      .image(Design.icon.attach.withTintColor(Design.color.iconBrand))
      .set(Design.state.button.brandTransparent)
      .hidden(true)
   }

   var foundUsersList: StackItemsModel { .init()
      .set(.activateSelector)
      .hidden(true)
      .set(.presenters([
         foundUserPresenter
      ]))
   }

   var pickedImagesPanel: PickedImagePanel<Design> { .init() }

//   var closeButton: ButtonModel { .init()
//      .title(Design.Text.title.close)
//      .textColor(Design.color.textBrand)
//   }

   var userNotFoundInfoBlock: Wrapped2Y<ImageViewModel, LabelModel> {
      Wrapped2Y(
         ImageViewModel()
            .image(Design.icon.userNotFound)
            .size(.square(275)),
         Design.label.body1
            .numberOfLines(0)
            .alignment(.center)
            .text(Design.Text.title.userNotFound)
      )
   }

   var transactOptionsBlock: TransactOptionsVM<Design> { .init()
      .hidden(true)
   }

   var recipientCell: SendCoinRecipentCell<Design> { .init() }

   var transactSuccessViewModel: TransactionStatusViewModel<Design> { .init() }

   // MARK: - Private

   private var foundUserPresenter: Presenter<FoundUser, WrappedY<ImageLabelLabelMRD>> {
      Presenter<FoundUser, WrappedY<ImageLabelLabelMRD>>() { work in
         let user = work.unsafeInput

         let name = user.name
         let surname = user.surname
         let thName = "@" + user.tgName.string

         let comboMRD =
            WrappedY(
               ImageLabelLabelMRD()
                  .setAll { avatar, username, nickname in
                     avatar
                        .contentMode(.scaleAspectFill)
                        .size(.square(Grid.x26.value))
                        .cornerRadius(Grid.x26.value / 2)
                     if let photo = user.photo, photo.count != 0 {
                        let urlString = TeamForceEndpoints.urlMediaBase + photo
                        avatar.url(urlString)
                     } else {
                        if let nameFirstLetter = user.name.string.first,
                           let surnameFirstLetter = user.surname.string.first
                        {
                           let text = String(nameFirstLetter) + String(surnameFirstLetter)
                           let image = text.drawImage(backColor: Design.color.backgroundBrand)
                           avatar
                              .backColor(Design.color.backgroundBrand)
                              .image(image)
                        }
                     }
                     username
                        .text("\(name.string) \(surname.string)")
                        .textColor(Design.color.text)
                        .padLeft(Grid.x14.value)
                        .height(Grid.x24.value)
                     nickname
                        .set(Design.state.label.caption)
                        .textColor(Design.color.textSecondary)
                        .text(thName)
                        .padLeft(Grid.x14.value)
                  }
                  .padding(Design.params.cellContentPadding)
                  .alignment(.center)
                  .backColor(Design.color.background)
                  .shadow(Design.params.cellShadow)
                  .height(68)
                  .cornerRadius(Design.params.cornerRadius)
                  .zPosition(1000)
            )
            .padding(.outline(4))

         work.success(result: comboMRD)
      }
   }
}
