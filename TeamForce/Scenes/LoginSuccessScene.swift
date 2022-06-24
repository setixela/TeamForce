//
//  LoginSuccessScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

// MARK: - LoginSuccessScene

final class LoginSuccessScene: BaseSceneModel<
    DefaultVCModel,
    StackWithBottomPanelModel,
    Asset,
    Void
> {

    private lazy var checkmarkIcon = ImageViewModel().setup {
        $0
            .set(\.size, .init(width: 48, height: 48))
            .set(\.image, Icons().make(\.checkCircle))
    }

    private lazy var headerModel = Design.label.headline4.setup {
        $0
            .set(\.alignment, .center)
            .set(\.numberOfLines, 2)
            .set(\.padding, UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0))
            .set(\.text, "Вы успешно зарегистрированы")
    }

    private lazy var nextButton = ButtonModel(state: Design.State.button.default)
        .setup {
            $0.set(\.title, "ВОЙТИ")
        }

    override func start() {

        mainViewModel.stackModel.updateState.set(\.alignment, .center)

        weak var weakSelf = self

        nextButton
            .onEvent(\.didTap) {
                print("Did tap")
            }

        vcModel?
            .onEvent(\.viewDidLoad) {
                weakSelf?.presentModels()
            }
    }

    private func presentModels() {
        mainViewModel
            .sendEvent(\.addViewModels, [
                Spacer(size: 100),
                checkmarkIcon,
                headerModel,
                Spacer(size: 16),
                Spacer()
            ])
            .sendEvent(\.addBottomPanelModel, nextButton)
    }
}
