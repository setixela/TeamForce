//
//  DigitalThanksScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import ReactiveWorks

// MARK: - DigitalThanksScene

final class DigitalThanksScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   DoubleStacksModel,
   Asset,
   Void
> {
   private lazy var enterButton = Design.button.default
      .title(Text.button.enterButton)

   // Debug
   private lazy var popup = BottomPopupPresenter()
   private lazy var popupTable = SimpleTableVM()
   private lazy var debugLabel = LabelModel()
      .text("Debug mode")
      .padding(.horizontalOffset(16))
      .height(50)
   private lazy var prodLabel = LabelModel()
      .text("Production mode")
      .padding(.horizontalOffset(16))
      .height(50)

   // MARK: - Start

   override func start() {
      //
      vcModel?.on(\.viewDidLoad, self) {
         $0.configure()

         $0.enterButton
            .on(\.didTap) {
               Asset.router?.route(.push, scene: \.login)
            }
      }
   }

   private func configure() {
      mainVM
         .backColor(Design.color.background)

      mainVM.bodyStack
         .set(Design.state.stack.default)
         .set(.alignment(.center))
         .arrangedModels([
            DTLogoTitleX<Design>(),
            Grid.xxx.spacer,
            ImageViewModel()
               .image(Design.icon.introlIllustrate)
               .size(.square(280))
         ])

      mainVM.footerStack
         .set(Design.state.stack.bottomPanel)
         .arrangedModels([
            Grid.x1.spacer,
            TitleSubtitleY<Design>()
               .padding(.top(Design.params.titleSubtitleOffset))
               .setMain {
                  $0
                     .text(Text.title.digitalThanks)
                     .padBottom(Grid.x8.value)
               } setDown: {
                  $0.text(Text.title.digitalThanksAbout)
               },
            Grid.x1.spacer,
            enterButton
         ])

      vcModel?.on(\.motionEnded, self) { slf, event in
         switch event {
         case .motionShake:
            slf.popupTable.models([
               slf.debugLabel,
               slf.prodLabel,
               Spacer(64)
            ])
            slf.popup.send(\.presentAuto, (slf.popupTable, onView: slf.vcModel?.view.superview))
         default:
            break
         }

         slf.popupTable.onEvent(\.didSelectRow) {
            switch $0.row {
            case 0:
               Config.setDebugMode(true)
            default:
               Config.setDebugMode(false)
            }
            slf.popup.send(\.hide)
         }
      }
   }
}
