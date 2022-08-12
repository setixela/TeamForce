//
//  DigitalThanksScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import ReactiveWorks
import UIKit

// MARK: - DigitalThanksScene

final class DigitalThanksScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   DoubleStacksModel,
   Asset,
   Void
> {
   //

   private lazy var logoTitle = SquashedX<LogoTitleVM<Asset>>()

   private lazy var illustration = ImageViewModel()
      .set(.image(Design.icon.make(\.introlIllustrate)))
      .set(.width(300))

   private lazy var headerModel = Design.label.headline3
      .set(.numberOfLines(2))
      .set(.padding(.init(top: 0, left: 0, bottom: 40, right: 0)))
      .set(.text(Text.title.make(\.digitalThanks)))
      .set(.alignment(.center))

   private lazy var enterButton = Design.button.default
      .set(.title(Text.button.make(\.enterButton)))

   // MARK: - Start

   override func start() {
      //
      configure()

      enterButton
         .onEvent(\.didTap) {
            Asset.router?.route(\.login, navType: .push)
         }
   }

   private func configure() {
      mainViewModel
         .set(.backColor(Design.color.background2))

      mainViewModel.topStackModel
         .set(Design.State.mainView.default)
         .set(.alignment(.fill))
         .set(.models([
            Spacer(100),
            logoTitle,
            Spacer(24),
            illustration,
            headerModel,
            Spacer()
         ]))

      mainViewModel.bottomStackModel
         .set(Design.State.mainView.bottomPanel)
         .set(.models([
            enterButton
         ]))
   }
}

final class LogoTitleVM<Asset: AssetProtocol>:
   Combos<SComboMR<ImageViewModel, ImageViewModel>>,
   Assetable
{
   let mainModel: ImageViewModel = .init()
   let rightModel: ImageViewModel = .init()

   override func start() {
      setMain {
         $0
            .set(.image(Design.icon.make(\.logo)))
            .set(.size(.square(32)))

      } setRight: {
         $0
            .set(.image(Design.icon.make(\.logoTitle)))
            .set(.padding(.init(top: 6, left: 12, bottom: 0, right: 0)))
      }
   }
}

// обжимает модель с двух сторон, для того чтобы центрировать в .fill стеках
final class SquashedX<VM: VMP>: BaseViewModel<UIStackView>, Stateable {
   typealias State = StackState

   let subModel = VM()

   override func start() {
      set(.axis(.horizontal))
      set(.distribution(.equalCentering))
      set(.models([
         Spacer(),
         subModel,
         Spacer()
      ]))
   }
}

// обжимает модель с двух сторон, для того чтобы центрировать в .fill стеках
final class SquashedY<VM: VMP>: BaseViewModel<UIStackView>, Stateable {
   typealias State = StackState

   let subModel = VM()

   override func start() {
      set(.axis(.vertical))
      set(.distribution(.equalCentering))
      set(.models([
         Spacer(),
         subModel,
         Spacer()
      ]))
   }
}
