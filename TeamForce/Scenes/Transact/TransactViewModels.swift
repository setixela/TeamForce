//
//  TransactScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 18.08.2022.
//
import ReactiveWorks
import UIKit

// MARK: - View models

final class BalanceInfo<Design: DSP>: Combos<SComboMD<LabelModel, CurrencyLabelDT<Design>>> {
   required init() {
      super.init()

      setAll { title, amount in
         title
            .set(Design.state.label.caption)
            .height(Grid.x20.value)
            .text("Доступно")
            .textColor(Design.color.iconInvert)
         amount.currencyLogo
            .width(Grid.x20.value)
      }
      alignment(.leading)
      height(Grid.x90.value)
      backColor(Design.color.iconContrast)
      cornerRadius(Design.params.cornerRadius)
      padding(Design.params.infoFramePadding)
      hidden(true)
   }
}

final class UserSearchTextField<Design: DSP>: TextFieldModel, Designable {
   required init() {
      super.init()

      set(Design.state.textField.default)
      placeholder(Design.Text.title.chooseRecipient)
      placeholderColor(Design.color.textFieldPlaceholder)
      disableAutocorrection()
      hidden(true)
   }
}

final class ReasonTextView<Design: DSP>: TextViewModel, Designable {
   required init() {
      super.init()

      padding(Design.params.contentPadding)
      placeholder(TextBuilder.title.reasonPlaceholder)
      set(Design.state.label.body1)
      backColor(Design.color.background)
      borderColor(Design.color.boundary)
      borderWidth(Design.params.borderWidth)
      cornerRadius(Design.params.cornerRadius)
      minHeight(144)
      hidden(true)
   }
}

// final class

final class TransactViewModels<Design: DSP>: Designable {
   //
   lazy var balanceInfo = BalanceInfo<Design>()
   lazy var userSearchTextField = UserSearchTextField<Design>()
   lazy var transactInputViewModel = TransactInputViewModel<Design>()
      .hidden(true)
   lazy var reasonTextView = ReasonTextView<Design>()

   lazy var foundUsersList = StackItemsModel()
      .set(.activateSelector)
      .hidden(true)
      .set(.presenters([
         foundUserPresenter
      ]))

   lazy var sendButton = Design.button.default
      .set(Design.state.button.inactive)
      .title(Design.Text.button.sendButton)

   lazy var addPhotoButton = ButtonModel()
      .title("Добавить фото")
      .image(Design.icon.attach.withTintColor(Design.color.iconBrand))
      .set(Design.state.button.brandTransparent)
      .hidden(true)
}

extension TransactViewModels {
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
