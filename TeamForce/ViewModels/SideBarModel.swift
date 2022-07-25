//
//  SideBarModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import UIKit

struct SideBarEvents: InitProtocol {
    var presentOnScene: Event<UIView>?
    var hide: Event<Void>?
}

final class SideBarModel<Asset: AssetProtocol>: BaseViewModel<UIStackView>,
    Communicable,
    Stateable,
    Assetable
{
    var eventsStore: SideBarEvents = .init()

    private var isPresented = false

    private lazy var userModel = SideBarUserModel<Design>()

    private lazy var item1 = IconLabelHorizontalModel<Asset>()
        .set(.padding(Design.Parameters.contentPadding))
        .set(.text("Баланс"))
        .set(.icon(Design.icon.make(\.coinLine)))

    private lazy var item2 = IconLabelHorizontalModel<Asset>()
        .set(.padding(Design.Parameters.contentPadding))
        .set(.text("Новый перевод"))
        .set(.icon(Design.icon.make(\.upload2Fill)))

    private lazy var item3 = IconLabelHorizontalModel<Asset>()
        .set(.padding(Design.Parameters.contentPadding))
        .set(.text("История"))
        .set(.icon(Design.icon.make(\.historyLine)))

    private lazy var userProfileApiModel = GetProfileApiModel(apiEngine: Asset.service.apiEngine)
    private lazy var safeStringStorage = StringStorageModel(engine: Asset.service.safeStringStorage)
    
    override func start() {
        view.backgroundColor = .white

        userModel.avatar.set(.image(Design.icon.make(\.avatarPlaceholder)))
//        userModel.userName.set(.text("Jonny777"))
//        userModel.nickName.set(.text("id 93248723984798"))

        set(.axis(.vertical))
            .set(.distribution(.fill))
            .set(.alignment(.leading))
            .set(.models([
                userModel,
                item1,
                item2,
                item3,
                Spacer()
            ]))

        onEvent(\.presentOnScene) { [weak self] baseView in
            self?.show(baseView: baseView)
        }
        .onEvent(\.hide) { [weak self] in
            self?.hide()
        }
        
        weak var weakSelf = self
        
        safeStringStorage
           .onEvent(\.responseValue) { token in
              weakSelf?.userProfileApiModel
                 .onEvent(\.success) { profile in
                     self.setProfileLabels(profile: profile)
                 }
                 .onEvent(\.error) {
                    print($0)
                 }
                 .sendEvent(\.request, TokenRequest(token: token))
           }
           .onEvent(\.error) {
              print($0)
           }
           .sendEvent(\.requestValueForKey, "token")
    }
    
    private func setProfileLabels(profile: UserData) {
        userModel.userName.set(.text(profile.userName))
        userModel.nickName.set(.text(profile.profile.nickName))
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
