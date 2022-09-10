//
//  ProfileBuilder.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.09.2022.
//

import ReactiveWorks

protocol ProfileModelBuilder: InitProtocol, Designable {
   var userNameTitleSubtitle: FullAndNickNameY<Design> { get }

   var userEditPanel: M<ImageViewModel>.R<FullAndNickNameY<Design>>.R2<ButtonModel>.Combo { get }
   var editPhotoBlock: EditPhotoBlock<Design> { get }

   var titledTextField: TitledTextFieldY<Design> { get }
}

struct ProfileBuilder<Design: DSP>: ProfileModelBuilder {
   var userEditPanel: M<ImageViewModel>.R<FullAndNickNameY<Design>>.R2<ButtonModel>.Combo { .init()
      .setMain { image in
         image
            .image(Design.icon.avatarPlaceholder)
            .cornerRadius(52 / 2)
            .set(.size(.square(52)))
      } setRight: { name in
         name.fullName
            .textColor(Design.color.text)
            .padLeft(Grid.x12.value)
            .height(Grid.x24.value)
         name.nickName
            .set(Design.state.label.defaultBrand)
            .padLeft(Grid.x12.value)
            .height(Grid.x24.value)
      } setRight2: { button in
         button
            .size(.square(24))
            .image(Design.icon.editCircle)
      }
      .alignment(.center)
      .distribution(.fill)
      .backColor(Design.color.background)
      .cornerRadius(Design.params.cornerRadius)
      .padding(Design.params.cellContentPadding)
      .shadow(Design.params.profileUserPanelShadow)
      .height(76)
   }

   var editPhotoBlock: EditPhotoBlock<Design> { .init() }

   var userNameTitleSubtitle: FullAndNickNameY<Design> { .init() }

   var titledTextField: TitledTextFieldY<Design> { .init()
      .setAll { main, down in
         main
            .alignment(.left)
            .set(Design.state.label.caption)
            .textColor(Design.color.textSecondary)
         down
            .alignment(.left)
            .set(Design.state.label.default)
            .textColor(Design.color.text)
      }
      .borderColor(Design.color.iconMidpoint)
      .borderWidth(1.0)
      .padding(.sideOffset(16))
      .cornerRadius(Design.params.cornerRadiusSmall)
      .alignment(.fill)
      .height(Grid.x48.value)
   }
}

final class EditPhotoBlock<Design: DSP>: M<ButtonModel>.R<FullAndNickNameY<Design>>.Combo, Designable {
   var photoButton: ButtonModel { models.main }
   var fullAndNickName: FullAndNickNameY<Design> { models.right }

   required init() {
      super.init()

      setAll { button, _ in
         button
            .size(.square(Grid.x60.value))
            .image(Design.icon.camera)
            .backImage(Design.icon.avatarPlaceholder)
            .cornerRadius(Grid.x60.value / 2)
      }

      alignment(.center)
      spacing(Grid.x16.value)
   }
}

final class FullAndNickNameY<Design: DSP>: M<LabelModel>.D<LabelModel>.Combo, Designable {
   var fullName: LabelModel { models.main }
   var nickName: LabelModel { models.down }

   required init() {
      super.init()

      setAll { fullName, telegram in
         fullName
            .textColor(Design.color.text)
            // .padLeft(Grid.x12.value)
            .height(Grid.x24.value)
         telegram
            .set(Design.state.label.defaultBrand)
            //  .padLeft(Grid.x12.value)
            .height(Grid.x24.value)
      }
   }
}

final class EditStack<Design: DSP>: StackModel, Designable {
   convenience init(title: String, models: [UIViewModel]) {
      self.init()

      arrangedModels(
         [
            LabelModel()
               .text(title)
               .set(Design.state.label.caption2)
               .textColor(Design.color.textSecondary)
               .padBottom(Grid.x8.value)
         ]
            + models
      )

      spacing(8)
      distribution(.equalSpacing)
      alignment(.fill)
   }
}

struct Contacts {
   var name: String?
   var surname: String?
   var middlename: String?
   var email: String?
   var phone: String?
}
