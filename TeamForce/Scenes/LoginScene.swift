//
//  LoginScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

// MARK: - LoginScene

final class LoginScene: BaseSceneModel<
    DefaultVCModel,
    StackWithBottomPanelModel,
    Asset,
    Void
> {
    private lazy var headerModel = Design.label.headline4.setup {
        $0
            .set(\.padding, UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0))
            .set(\.text, "Вход")
    }

    private lazy var subtitleModel = Design.label.subtitle.setup {
        $0
            .set(\.padding, UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0))
            .set(\.text, "1. Для входа нажмите ”получить код”, или смените пользователя ")
            .set(\.numberOfLines, 2)
    }

    private lazy var nextButton = Design.button.inactive.setup {
        $0.set(\.title, "ПОЛУЧИТЬ КОД")
    }

    private lazy var changeUserButton = Design.button.transparent.setup {
        $0.set(\.title, "СМЕНИТЬ ПОЛЬЗОВАТЕЛЯ")
    }

    private lazy var textFieldModel = TextFieldModel()
    private lazy var inputParser = TelegramNickCheckerModel()

    override func start() {
        weak var weakSelf = self

        nextButton
            .onEvent(\.didTap) {
                Asset.router?.route(\.verifyCode, navType: .push)
                print("Did tap")
            }

        textFieldModel
            .onEvent(\.didEditingChanged) { text in
                weakSelf?.inputParser.sendEvent(\.request, text)
            }
            .sendEvent(\.setPlaceholder, "@Имя пользователя")

        inputParser
            .onEvent(\.response) { text in
                weakSelf?.textFieldModel.sendEvent(\.setText, text)
                weakSelf?.nextButton.setup(Design.State.button.default)
            }
            .onEvent(\.error) { text in
                weakSelf?.textFieldModel.sendEvent(\.setText, text)
                weakSelf?.nextButton.setup(Design.State.button.inactive)
            }

        presentModels()
    }

    private func presentModels() {
        mainViewModel
            .sendEvent(\.addViewModels, payload: [
                Spacer(size: 100),
                headerModel,
                subtitleModel,
                Spacer(size: 16),
                textFieldModel,
                Spacer()
            ])
            .sendEvent(\.addBottomPanelModel, payload: nextButton)
            .sendEvent(\.addBottomPanelModel, payload: changeUserButton)
    }
}
