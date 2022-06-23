//
//  DigitalThanksScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

// MARK: - DigitalThanksScene

final class DigitalThanksScene: BaseSceneModel<
    DefaultVCModel,
    StackModel,
    Asset,
    Void
> {
    private lazy var headerModel = DesignSystem.label.headline3
        .setup {
            $0
                .set(\.numberOfLines, 2)
                .set(\.padding, UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0))
                .set(\.text, "Цифровое спасибо")
                .set(\.alignment, .center)
        }

    private lazy var enterButton = DesignSystem.button.default
        .setup {
            $0.set(\.title, "ВХОД")
        }

    private lazy var registerButton = DesignSystem.button.transparent
        .setup {
            $0.set(\.title, "РЕГИСТРАЦИЯ")
        }

    override func start() {
        weak var weakSelf = self

        enterButton
            .onEvent(\.didTap) {
                Asset.router?.route(\.login, navType: .push)
                print("Did tap")
            }

        registerButton
            .onEvent(\.didTap) {
                Asset.router?.route(\.register, navType: .push)
                print("Did tap")
            }

        vcModel?
            .onEvent(\.viewDidLoad) {
                guard let self = weakSelf else { return }

                self.setupMainViewModel()
                self.presentModels()
            }
    }

    private func setupMainViewModel() {
        mainViewModel.setup(DesignSystem.Setup.mainView.default)
    }

    private func presentModels() {
        mainViewModel.sendEvent(\.addViewModels, payload: [
            Spacer(size: 100),
            headerModel,
            enterButton,
            Spacer(size: 16),
            registerButton,
            Spacer()
        ])
    }
}

