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
   private let titleModel = ProfileTitle<Design>()

   private lazy var settingsButton = Design.button.secondary
      .title("Настройки")
      .on(\.didTap) { [weak self] in
         guard let id = self?.userId else {
            return
         }
         Asset.router?.route(.presentModally(.automatic), scene: \.settings, payload: id)
      }

   private lazy var topPopupPresenter = Design.model.common.topPopupPresenter
   private lazy var bottomPopupPresenter = Design.model.common.bottomPopupPresenter

   private lazy var editProfileModel = ProfileEditScene<Asset>(vcModel: vcModel)

   private let test = TableViewModel()
      .set(.models([
         LabelModel().text("     1"),
         LabelModel().text("     2"),
         LabelModel().text("     3"),
         LabelModel().text("     4")
      ]))
      .backColor(Design.color.background)
   
   override func start() {
      vcModel?.titleModel(titleModel)
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

      titleModel.view.startTapGestureRecognize()
      titleModel.view.on(\.didTap, self) { slf in
         slf.topPopupPresenter.send(\.present, (slf.test, slf.vcModel?.view.rootSuperview))

      }
   }

   //
   //   private func getOrganizations() {
   //      useCase.getUserOrganizations
   //         .doAsync()
   //         .onSuccess {
   //            print("result \($0)")
   //         }
   //         .onFail {
   //            print("fail")
   //         }
   //   }
   //
   //   private func changeOrganization(id: Int) {
   //      useCase.changeOrganization
   //         .doAsync(id)
   //         .onSuccess {
   //            print($0)
   //            let smsCode = ""
   //            var request = VerifyRequest(xId: $0.xId,
   //                                        xCode: $0.xCode,
   //                                        smsCode: smsCode ?? "",
   //                                        organizationId: $0.organizationId)
   //            self.verifyCode(request: request)
   //         }
   //         .onFail {
   //            print("fail")
   //         }
   //   }
   //
   //   private func verifyCode(request: VerifyRequest) {
   //      useCase.changeOrgVerifyCode
   //         .doAsync(request)
   //         .onSuccess {
   //            print($0)
   //            print("success")
   //         }
   //         .onFail {
   //            print("fail")
   //         }
   //   }
}
