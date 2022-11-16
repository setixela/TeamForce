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

   private lazy var useCase = Asset.apiUseCase
   private var organizations: [Organization] = []

   private let test = TableViewModel()
      .backColor(Design.color.background)

   override func start() {
      vcModel?.titleModel(titleModel)
      super.start()
   }

   override func configure() {
      configureTable()
      configureEvents()

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

   private func configureTable() {
      useCase.getUserOrganizations
         .doAsync()
         .onSuccess {
            self.organizations = $0
            print("result \($0)")
            let orgNames = $0.map(\.name)
            var labelModels: [UIViewModel] = [Spacer(1)]

            let icon = ImageViewModel()
               .contentMode(.scaleAspectFill)
               .image(Design.icon.anonAvatar)
               .size(.square(Grid.x36.value))
               .cornerRadius(Grid.x36.value / 2)

            for orgName in orgNames {
               let label = LabelModel().text(orgName ?? "")
               let cellStack2 = WrappedX(
                  StackModel()
                     .spacing(Grid.x12.value)
                     .axis(.horizontal)
                     .alignment(.center)
                     .arrangedModels([
                        Spacer(16),
                        icon,
                        label
                     ])
               )
               .backColor(Design.color.background)

               labelModels.append(cellStack2)
            }

            self.test.set(.models(labelModels))
         }
         .onFail {
            print("fail")
         }
   }

   private func configureEvents() {
      test.onEvent(\.didSelectRow) {
         print($0)
         let index = $0.row - 1
         let id = self.organizations[index].id
         self.useCase.changeOrganization
            .doAsync(id)
            .onSuccess {
               print($0)
               let authResult = AuthResult(xId: $0.xId,
                                           xCode: $0.xCode,
                                           account: $0.account,
                                           organizationId: $0.organizationId)
               self.topPopupPresenter.hideView()
               Asset.router?.route(.push, scene: \.verify, payload: authResult)
            }
            .onFail {
               print("fail")
            }
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
