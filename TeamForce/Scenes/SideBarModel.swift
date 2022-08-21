//
//  SideBarModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import ReactiveWorks
import UIKit

struct SideBarEvents: InitProtocol {
   var presentOnScene: Event<UIView>?
   var hide: Event<Void>?
}

final class SideBarModel<Asset: AssetProtocol>: BaseViewModel<StackViewExtended>,
   Communicable,
   Stateable,
   Assetable
{
   typealias State = StackState
   var events: SideBarEvents = .init()

   private var isPresented = false

   private lazy var userModel = SideBarUserModel<Design>()

   internal lazy var item1 = IconLabelX<Asset>()
      .set(.padding(Design.params.contentPadding))
      .set(.text("Баланс"))
      .set(.icon(Design.icon.coinLine))

   internal lazy var item2 = IconLabelX<Asset>()
      .set(.padding(Design.params.contentPadding))
      .set(.text("Новый перевод"))
      .set(.icon(Design.icon.upload2Fill))

   internal lazy var item3 = IconLabelX<Asset>()
      .set(.padding(Design.params.contentPadding))
      .set(.text("История"))
      .set(.icon(Design.icon.historyLine))

   private lazy var item4 = IconLabelX<Asset>()
      .set(.padding(Design.params.contentPadding))
      .set(.text("Выход"))

   // MARK: - Use Cases

   private lazy var useCase = Asset.apiUseCase

   override func start() {
      view.backgroundColor = .white

      userModel.avatar.set(.image(Design.icon.avatarPlaceholder))

      set_axis(.vertical)
         .set_distribution(.fill)
         .set_alignment(.leading)
         .set_arrangedModels([
            userModel,
            item1,
            item2,
            item3,
            item4,
            Spacer()
         ])

      onEvent(\.presentOnScene) { [weak self] baseView in
         self?.show(baseView: baseView)
      }
      .onEvent(\.hide) { [weak self] in
         self?.hide()
      }

      configureLoadProfileUseCase()
      configureLogoutUseCase()

      userModel
         .onEvent(\.didTap) {
            print("User model did tap")
            ProductionAsset.router?.route(\.profile, navType: .push, payload: ())
         }
   }
}

// MARK: - Configure use cases

extension SideBarModel {
   private func configureLoadProfileUseCase() {
      useCase.loadProfile.work
         .onSuccess { [weak self] user in
            self?.userModel.userName.set(.text(user.profile.tgName))
            self?.userModel.nickName.set(.text(user.profile.tgId))
         }
         .onFail {
            print("profile loading error")
         }
   }

   private func configureLogoutUseCase() {
      item4
         .onEvent(\.didTap)
         .doNext(usecase: useCase.logout)
         .onSuccess {
            UserDefaults.standard.setIsLoggedIn(value: false)
            Asset.router?.route(\.digitalThanks, navType: .present, payload: ())
         }.onFail {
            print("logout api failed")
         }
   }
}

extension SideBarModel {
   private func show(baseView: UIView) {
      guard isPresented == false else {
         sendEvent(\.hide)
         return
      }

      print("\nSHOW\n")

      view.removeFromSuperview()

      let size = baseView.frame.size
      let origin = baseView.frame.origin
      view.frame.size = CGSize(width: size.width * 0.8, height: size.height)
      view.frame.origin = CGPoint(x: -size.width, y: origin.y)
      baseView.addSubview(view)
      isPresented = true
      UIView.animate(withDuration: 0.25) {
         self.view.frame.origin = origin
      }
   }

   private func hide() {
      print("\nHIDE\n")
      isPresented = false

      UIView.animate(withDuration: 0.25) {
         self.view.frame.origin = CGPoint(x: -self.view.frame.size.width, y: 0)
      }
   }
}
