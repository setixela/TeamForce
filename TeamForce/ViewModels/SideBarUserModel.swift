//
//  SideBarUserModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import UIKit

final class SideBarUserModel<Design: DesignProtocol>: BaseViewModel<UIStackView>,
    Communicable,
    Stateable,
    Designable
{
    var eventsStore: SideBarEvents = .init()

    lazy var avatar = ImageViewModel()
        .set(.size(.init(width: 64, height: 64)))

    lazy var userName = Design.label.headline6
    lazy var nickName = Design.label.body2

    override func start() {
        set(.axis(.vertical))
            .set(.distribution(.equalSpacing))
            .set(.alignment(.leading))
            .set(.padding(.init(top: 12, left: 16, bottom: 12, right: 16)))
            .set(.models([
                avatar,
                Spacer(size: 30),
                userName,
                Spacer(size: 4),
                nickName
            ]))
    }
}
