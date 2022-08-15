//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import ReactiveWorks
import UIKit

func example(_ name: String = "", action: () -> Void) {
   print("\n--- Example \(name):")
   action()
}

if false {
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
} else {
   PlaygroundPage.current.needsIndefiniteExecution = true
}

let historyModel = LoginScene<ProductionAsset>()

final class LoginScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   Combos<SComboMD<StackModel, StackModel>>,
   Asset,
   Void
> {
   // MARK: - View Models

   private let nextButton = Design.button.inactive
      .setTitle(Text.button.getCodeButton)

   private let badgeModel = BadgeModel<Asset>()

   private let loginTextField = Combos { (model: ImageViewModel) in
      model
         .setSize(.square(Grid.x24.value))
         .setImage(Design.icon.user)
   } setRight: { (model: TextFieldModel<Design>) in
      model
         .set(Design.state.textField.default)
      // TextFieldModel<Design>(Design.state.textField.default)
      // .setPlaceholder("")
   }

//   TextFieldModel<Design>(Design.state.textField.default)
//      .setPlaceholder("")

   private lazy var bottomPanel = StackModel()
      .set(Design.state.stack.bottomPanel)
      .setCornerRadius(Design.params.cornerRadiusMedium)
      .setShadow(.init(radius: 8, color: Design.color.iconContrast, opacity: 0.33))
      .setModels([
         Grid.x16.spacer,
         //  badgeModel,
         loginTextField,
         nextButton,
         Grid.xxx.spacer
      ])

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
         .doNext(worker: telegramNickParser)
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
      mainVM.setMain { topStack in
         topStack
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
               Grid.x36.spacer
            ])
      } setDown: { bottomStack in
         bottomStack
            // чтобы сделать offset с тенью
            .setPadding(.top(-Grid.x16.value))
            .setModels([
               // обернули в еще один стек, чтобы сделать offset с тенью
               bottomPanel
            ])
      }
   }
}




class TempStore: InitProtocol {
   required init() {}

   var tokens: (token: String, csrf: String) = ("", "")
   var foundUsers: [FoundUser] = []
   var recipientID = 0
   var recipientUsername = ""

   var inputAmountText = ""
   var inputReasonText = ""
}

// static var tempStorage: TempStore = .init()
var store: TempStore = .init()

// MARK: - Works

UnsafeTemper.initStore(for: TempStore.self)

UnsafeTemper.store(for: TempStore.self)
   .tokens.token = "A"

print(UnsafeTemper.store(for: TempStore.self).tokens.token)

enum UnsafeTemper {
   private static var storage: [String: InitAnyObject] = [:]

   static func initStore(for type: InitAnyObject.Type) {
      let key = String(reflecting: type)
      let new = type.init()

      storage[key] = new
   }

   static func store<T: InitAnyObject>(for type: T.Type) -> T {
      let key = String(reflecting: type)

      guard let value = storage[key] as? T else {
         fatalError()
      }

      return value
   }

   static func clearStore(for type: InitAnyObject.Type) {
      let key = String(reflecting: type)

      storage[key] = nil
   }
}
