//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.12.2022.
//

import ReactiveWorks

// MARK: - ProfileUserBlock

final class ProfileUserBlock<Design: DSP>: M<UserAvatarVM<Design>>.R<Spacer>.R2<ButtonModel>.Combo,
                                           Designable
{
   var avatarButton: UserAvatarVM<Design> { models.main }
   var notifyButton: ButtonModel { models.right2 }

   required init() {
      super.init()

      setAll { avatar, _, notifyButton in
         avatar.setState(.size(48))
         notifyButton
            .image(Design.icon.alarm, color: Design.color.iconContrast)
            .size(.square(36))
      }

      alignment(.center)
   }
}

