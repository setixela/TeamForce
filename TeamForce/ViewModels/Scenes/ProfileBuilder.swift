//
//  ProfileBuilder.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.09.2022.
//

import ReactiveWorks

protocol ProfileModelBuilder: InitProtocol, Designable {
   var userEditPanel: M<ImageViewModel>.R<LabelModel>.D<LabelModel>.R2<ButtonModel>.Combo { get }
   var titledTextField: TitledTextFieldY<Design> { get }
}

struct ProfileBuilder<Design: DSP>: ProfileModelBuilder {
   var userEditPanel: M<ImageViewModel>.R<LabelModel>.D<LabelModel>.R2<ButtonModel>.Combo { .init()
      .setMain { image in
         image
            .image(Design.icon.avatarPlaceholder)
            .cornerRadius(52 / 2)
            .set(.size(.square(52)))
      } setRight: { fullName in
         fullName
            .textColor(Design.color.text)
            .padLeft(Grid.x12.value)
            .height(Grid.x24.value)
      } setDown: { telegram in
         telegram
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
