//
//  VerifyCodeScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

// MARK: - VerifyCodeScene

final class VerifyCodeScene: BaseSceneModel<
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
            .set(\.text, "2. Введите код")
            .set(\.numberOfLines, 2)
    }

    private lazy var nextButton = ButtonModel(state: DesignSystem.Setup.buttonStateBuilder.inactive)
        .setup {
            $0.set(\.title, "ВОЙТИ")
        }

    private lazy var textFieldModel = TextFieldModel()

    private lazy var inputParser = SmsCodeCheckerModel()

    override func start() {
        weak var weakSelf = self

        nextButton
            .onEvent(\.didTap) {
                Asset.router?.route(\.loginSuccess, navType: .push)
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
            .sendEvent(\.addViewModels, [
                Spacer(size: 100),
                headerModel,
                subtitleModel,
                Spacer(size: 16),
                textFieldModel,
                Spacer()
            ])
            .sendEvent(\.addBottomPanelModel, nextButton)
    }
}
