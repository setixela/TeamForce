//
//  ProfileViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 27.07.2022.
//

import UIKit
import ReactiveWorks

final class ProfileViewModel<Asset: AssetProtocol>: BaseSceneModel<
    DefaultVCModel,
    StackWithBottomPanelModel,
    Asset,
    Void
> {
    private lazy var userModel = SideBarUserModel<Design>()
        .set(.backColor(UIColor.lightGray.withAlphaComponent(0.5)))

    private lazy var infoTableModel = TableViewModel()

    // MARK: - Services

    private lazy var userProfileApiModel = ProfileApiWorker(apiEngine: Asset.service.apiEngine)
    private lazy var safeStringStorageModel = StringStorageWorker(engine: Asset.service.safeStringStorage)

    private var balance: Balance?
   
    override func start() {
        configure()
        configureProfile()
    }

    private func configure() {
        mainViewModel
            .set(Design.State.mainView.default)
            .set(.backColor(Design.color.background2))

        mainViewModel
            .set(.models([
                userModel,
                Spacer(16),
                infoTableModel,
                Spacer()
            ]))
    }

    private func configureProfile() {

        safeStringStorageModel
            .doAsync("token")
            .onFail {
                print("token not found")
            }
            .doMap {
                TokenRequest(token: $0)
            }
            .doNext(worker: userProfileApiModel)
            .onSuccess { [weak self] userData in
                self?.setUserModelLabels(userData: userData)
                self?.setProfileCells(userData: userData)
            }.onFail {
                print("load profile error")
            }
    }

    private func setUserModelLabels(userData: UserData) {
        let profile = userData.profile
        userModel.avatar.set(.image(Design.icon.make(\.avatarPlaceholder)))
        userModel.userName.set(.text(profile.tgName))
        userModel.nickName.set(.text(profile.tgId))
    }

    private func setProfileCells(userData: UserData) {
        print("PROFILE: \(userData)")
        let profile = userData.profile
        let fullName = profile.surName + " " +
            profile.firstName + " " +
            profile.middleName
        let cell1 = CustomCellModel<Design>(title: "ФИО", label: fullName)
        let cell2 = CustomCellModel<Design>(title: "Юр.лицо", label: profile.organization)
        let cell3 = CustomCellModel<Design>(title: "Подразделение", label: profile.department)
        let cell4 = CustomCellModel<Design>(title: "Дата начала работы", label: profile.hiredAt)
        let cell5 = CustomCellModel<Design>(title: "Телефон", label: "Нет в базе данных")
        let cell6 = CustomCellModel<Design>(title: "Email", label: "Нет в базе данных")

        infoTableModel.set(.models([
            cell1,
            cell2,
            cell3,
            cell4,
            cell5,
            cell6
        ]))
    }
}
