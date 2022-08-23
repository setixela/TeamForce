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
   lazy var balanceInfo = Combos<SComboMD<LabelModel, CurrencyLabelDT<Design>>>()
      .setAll { title, _ in
         title
            .set_font(Design.font.caption)
            .set_text("Доступно")
            .set_color(Design.color.iconInvert)
      }
      .set_alignment(.leading)
      .set_height(Grid.x90.value)
      .set_backColor(Design.color.iconContrast)
      .set_cornerRadius(Design.params.cornerRadius)
      .set_padding(Design.params.infoFramePadding)

   lazy var userSearchTextField = TextFieldModel()
      .set(Design.state.textField.default)
      .set_placeholder(Design.Text.title.chooseRecipient)
      .set_hidden(true)

   lazy var transactInputViewModel = TransactInputViewModel<Design>()
      .set_hidden(true)
      .set_alignment(.center)

   lazy var foundUsersList = StackItemsModel() //   TableItemsModel<Design>()
      .set(.activateSelector)
      //.set_minHeight(300)
      .set_hidden(true)
      .set(.presenters([
         foundUserPresenter
      ]))

   lazy var sendButton = Design.button.default
      .set(Design.state.button.inactive)
      .set_title(Design.Text.button.sendButton)
      .set_hidden(true)

   lazy var reasonTextView = TextViewModel()
      .set(.padding(Design.params.contentPadding))
      .set(.placeholder(TextBuilder.title.reasonPlaceholder))
      .set(.font(Design.font.body1))
      .set_backColor(Design.color.background)
      .set_borderColor(Design.color.boundary)
      .set_borderWidth(Design.params.borderWidth)
      .set_minHeight(166)
      .set_hidden(true)

   lazy var addPhotoButton = ButtonModel()
      .set_title("Добавить фото")
      .set_image(Design.icon.attach.withTintColor(Design.color.iconBrand))
      .set(Design.state.button.brandTransparent)

   lazy var transactionStatusView = TransactionStatusViewModel<Design>()
}

extension TransactViewModels {
   private var foundUserPresenter: Presenter<FoundUser, WrappedY<ImageLabelLabelMRD>> {
      Presenter<FoundUser, WrappedY<ImageLabelLabelMRD>>() { work in
         let user = work.unsafeInput

         let urlString = "https://picsum.photos/200" // user.photo
         let name = user.name
         let surname = user.surname
         let thName = "@" + user.tgName

         log(urlString)

         let comboMRD =
            WrappedY(
               ImageLabelLabelMRD()
                  .setAll { avatar, username, nickname in
                     avatar
                        .set_size(.square(Grid.x26.value))
                        .set_url(urlString)
                     username
                        .set_text("\(name) \(surname)")
                        .set_color(Design.color.text)
                        .set_padLeft(Grid.x14.value)
                        .set_height(Grid.x24.value)
                     nickname
                        .set_font(Design.font.caption)
                        .set_color(Design.color.textSecondary)
                        .set_text(thName)
                        .set_padLeft(Grid.x14.value)
                        //.set_height(Grid.x20.value)
                  }
                  .set_padding(Design.params.cellContentPadding)
                  .set_alignment(.center)
                  .set_backColor(Design.color.background)
                  .set_shadow(Design.params.cellShadow)
                  .set_height(68)
                  .set_cornerRadius(Design.params.cornerRadius)
                  .set_zPosition(1000)
            )
            .set_padding(.outline(4))


         work.success(result: comboMRD)
      }
   }
}
