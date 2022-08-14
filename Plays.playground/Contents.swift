//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import ReactiveWorks
import UIKit

func example(_ name: String = "", action: () -> Void) {
   print("\n--- Example \(name):")
   action()
}

let nc = UINavigationController()
nc.view.frame = CGRect(x: 0, y: 0, width: 360, height: 640)
PlaygroundPage.current.liveView = nc

///////// """ STATEABLE -> PARAMETRIC """

///// MARK: - СДЕЛАТЬ АНИМАЦИЮ ПОЯВЛЕНИЯ БЛОКОВ

class VC: UIViewController {
   override func loadView() {
      view = historyModel.makeMainView()
   }
}

let vc = VC()
nc.viewControllers = [vc]

let historyModel = LoginScene<ProductionAsset>()

final class LoginScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   Combos<SComboMD<StackModel, StackModel>>,
   Asset,
   Void
> {
   // MARK: - View Models

   private let coverViewModel = CoverViewModel<Asset>()
      .setBackImage(Design.icon.introlIllustrate)

   private let headerModel = Design.label.headline4
      .setPadding(.init(top: 12, left: 0, bottom: 24, right: 0))
      .setText(Text.title.enter)

   private let subtitleModel = Design.label.subtitle
      .setPadding(.init(top: 0, left: 0, bottom: 32, right: 0))
      .setText(Text.title.enterTelegramName)
      .setNumberOfLines(2)

   private let nextButton = Design.button.inactive
      .setTitle(Text.button.getCodeButton)

   private let badgeModel = BadgeModel<Asset>()

   private let loginTextField = TextFieldModel<Design>(Design.state.textField.default)
      .setPlaceholder("")

   // MARK: - Use Cases

   private lazy var useCase = Asset.apiUseCase

   // MARK: - Private

   private let telegramNickParser = TelegramNickCheckerModel()
   // private var loginName: String?

   // MARK: - Start

   override func start() {
      configure()

      weak var weakSelf = self

      var loginName: String?

      badgeModel
         .setLabels(title: Text.title.userName,
                    placeholder: "@" + Text.title.userName,
                    error: Text.title.wrongUsername)

      nextButton
         .onEvent(\.didTap)
         .doInput {
            loginName
         }
         .onFail {
            print("login name is nil")
         }
         .doNext(usecase: useCase.login)
         .onSuccess {
            Asset.router?.route(\.verifyCode, navType: .push, payload: $0)
         }
         .onFail {
            weakSelf?.badgeModel.changeState(to: BadgeState.error)
         }

      badgeModel.textFieldModel
         .onEvent(\.didEditingChanged)
         .doNext {
            weakSelf?.badgeModel.changeState(to: BadgeState.default)
         }
         .doNext(worker: TelegramNickCheckerModel())
         .onSuccess { text in
            loginName = text // String(text.dropFirst())
            weakSelf?.badgeModel.textFieldModel
               .setText(text)
            weakSelf?.nextButton
               .set(Design.state.button.default)
         }
         .onFail { (text: String) in
            loginName = nil
            weakSelf?.badgeModel.textFieldModel
               .setText(text)
            weakSelf?.nextButton
               .set(Design.state.button.inactive)
         }
   }

   private func configure() {
      mainVM.setMain {
         $0
            .set(Design.state.stack.default)
            .setBackColor(Design.color.backgroundBrand)
            .setAlignment(.leading)
            .setModels([
               // spacer
               Grid.x16.spacer,
               // logo
               BrandLogoIcon<Design>(),
               // spacer
               Grid.x16.spacer,
               // title
               Design.label.headline5
                  .setText(Text.title.autorisation)
                  .setColor(Design.color.textInvert),
               // spacer
               Grid.x36.spacer,
            ])
      } setDown: {
         let stack = StackModel()
            .set(Design.state.stack.bottomPanel)
            .setCornerRadius(Design.params.cornerRadiusMedium)
            .setShadow(.init(radius: 8,
                             offset: .init(x: 0, y: 0),
                             color: Design.color.iconContrast,
                             opacity: 0.33))
            .setModels([
               Grid.x16.spacer,
               badgeModel,
               loginTextField,
               nextButton,
               Spacer(),
            ])

         $0
            .setPadding(.init(top: -Grid.x16.float,
                              left: 0,
                              bottom: 0,
                              right: 0))
            .setModels([
               stack,
            ])
      }
   }
}

final class ViewModel: BaseViewModel<UIView> {
   override func start() {}
}

extension ViewModel: Stateable {
   typealias State = ViewState
}

final class Wrapper<VM: VMP>: BaseViewModel<UIStackView>,
   VMWrapper,
   Stateable2
{
   var subModel: VM = .init()

   override func start() {
      setModels([
         subModel,
      ])
   }
}

