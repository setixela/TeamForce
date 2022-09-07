//
//  ProfileBuilder.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.09.2022.
//

import ReactiveWorks

protocol ProfileModelBuilder: InitProtocol, Designable {
   var userEditPanel: M<ImageViewModel>.R<LabelModel>.D<LabelModel>.R2<ButtonModel>.Combo { get }
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
            .height(Grid.x20.value)
      } setDown: { telegram in
         telegram
            .textColor(Design.color.textBrand)
            .padLeft(Grid.x12.value)
            .height(Grid.x20.value)
            .set(Design.state.label.body2)
      } setRight2: { button in
         button
            .size(.square(24))
            .backImage(Design.icon.editCircle)
      }
      .alignment(.center)
      .distribution(.fill)
      .backColor(Design.color.background)
      .cornerRadius(Design.params.cornerRadius)
      .padding(Design.params.cellContentPadding)
      .shadow(Design.params.profileUserPanelShadow)
      .height(76)
   }
}
