//
//  ProfileViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 27.07.2022.
//

import ReactiveWorks
import UIKit

struct ProfileEvents: InitProtocol {
   var saveSuccess: Void?
}

final class MyProfileScene<Asset: AssetProtocol>: ProfileScene<Asset> {
   //
  // private let titleModel = ProfileTitle<Design>()

   private lazy var settingsButton = Design.button.secondary
      .title("Настройки")
      .on(\.didTap) { [weak self] in
         guard let userData = self?.userData else {
            return
         }
         Asset.router?.route(.push, scene: \.settings, payload: userData)
      }

   private lazy var topPopupPresenter = Design.model.common.topPopupPresenter
   private lazy var bottomPopupPresenter = Design.model.common.bottomPopupPresenter

   private lazy var editProfileModel = ProfileEditScene<Asset>(vcModel: vcModel)

   private lazy var useCase = Asset.apiUseCase
   private var organizations: [Organization] = []


   override func start() {
      vcModel?.title("Мой профиль")
      super.start()
   }

   override func configure() {
      mainVM.bodyStack.arrangedModels(
         userModel,
         Spacer(32),
         infoStack,
         Spacer(8),
         infoStackSecondary,
         Spacer(8),
         settingsButton,
         Grid.xxx.spacer
      )

      userModel.models.right2.on(\.didTap, self) { slf in
         slf.bottomPopupPresenter.send(\.present, (slf.editProfileModel, slf.vcModel?.view.rootSuperview))
         slf.editProfileModel.closeButton.on(\.didTap) {
            slf.bottomPopupPresenter.send(\.hide)
         }

         slf.editProfileModel.on(\.saveSuccess) {
            slf.editProfileModel.clearcontactModelsStock()
            slf.editProfileModel.scenario.start()
            slf.configureProfile()
            slf.bottomPopupPresenter.send(\.hide)
         }
      }
   }
}
