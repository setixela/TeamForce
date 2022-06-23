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
    private lazy var headerModel = DesignSystem.label.headline4.setup {
        $0
            .set(\.padding, UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0))
            .set(\.text, "Вход")
    }

    private lazy var subtitleModel = DesignSystem.label.subtitle.setup {
        $0
            .set(\.padding, UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0))
            .set(\.text, "1. Для входа нажмите ”получить код”, или смените пользователя ")
            .set(\.numberOfLines, 2)
    }

    private lazy var nextButton = ButtonModel(state: DesignSystem.Setup.buttonStateBuilder.inactive)
        .setup {
            $0.set(\.title, "ПОЛУЧИТЬ КОД")
        }

    private lazy var changeUserButton = ButtonModel(state: DesignSystem.Setup.buttonStateBuilder.transparent)
        .setup {
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

        vcModel?
            .onEvent(\.viewDidLoad) {
                weakSelf?.setupLoginField()
                weakSelf?.presentModels()
            }
    }

    private func setupLoginField() {
        textFieldModel
            .onEvent(\.didEditingChanged) { [weak self] text in
                self?.inputParser.sendEvent(\.request, text)
            }
            .sendEvent(\.setPlaceholder, "@Имя пользователя")
        inputParser
            .onEvent(\.response) { [weak self] text in
                self?.textFieldModel.sendEvent(\.setText, text)
                self?.nextButton.setup(DesignSystem.Setup.buttonStateBuilder.default)
            }
            .onEvent(\.error) { [weak self] text in
                self?.textFieldModel.sendEvent(\.setText, text)
                self?.nextButton.setup(DesignSystem.Setup.buttonStateBuilder.inactive)
            }
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
