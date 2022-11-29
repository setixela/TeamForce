//
//  ProfileEditSceneViewModels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 09.09.2022.
//

import Foundation
import ReactiveWorks

final class ProfileEditViewModels<Design: DSP>: Designable {
   lazy var editPhotoBlock = Design.model.profile.editPhotoBlock
}

extension ProfileEditViewModels: SetupProtocol {
   func setup(_ data: UserData) {
      let profile = data.profile
      let fullName = profile.surName.string + " " +
         profile.firstName.string + " " +
         profile.middleName.string
      editPhotoBlock.fullAndNickName.fullName.text(fullName)
      editPhotoBlock.fullAndNickName.nickName.text("@" + profile.tgName.string)
      editPhotoBlock.photoButton.backImageUrl(TeamForceEndpoints.urlBase + profile.photo.string)
   }
}
