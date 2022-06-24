//
//  RegisterScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

// MARK: - RegisterScene

final class RegisterScene: BaseSceneModel<
    DefaultVCModel,
    StackWithBottomPanelModel,
    Asset,
    Void
> {
    private lazy var headerModel = Design.label.headline4.setup {
        $0
            .set(\.padding, UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0))
            .set(\.text, text.title.make(\.register))
    }

    private lazy var subtitleModel = Design.label.subtitle.setup {
        $0
            .set(\.padding, UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0))
            .set(\.text, "1. " + text.title.make(\.enterTelegramName))
            .set(\.numberOfLines, 2)
    }

    private lazy var nextButton = ButtonModel(state: Design.State.button.inactive)
        .setup {
            $0.set(\.title, text.button.nextButton)
        }

    private lazy var textFieldModel = TextFieldModel()

    private lazy var inputParser = TelegramNickCheckerModel()

    override func start() {
        weak var weakSelf = self

        nextButton
            .onEvent(\.didTap) {
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
            .sendEvent(\.setPlaceholder, "@" + text.title.make(\.userName))

        inputParser
            .onEvent(\.response) { [weak self] text in
                self?.textFieldModel.sendEvent(\.setText, text)
                self?.nextButton.setup(Design.State.button.default)
            }
            .onEvent(\.error) { [weak self] text in
                self?.textFieldModel.sendEvent(\.setText, text)
                self?.nextButton.setup(Design.State.button.inactive)
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
    }
}
