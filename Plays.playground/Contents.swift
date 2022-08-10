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

//   .setLeft {
//      $0
//         .set(.backColor(.blue))
//         .set(.size(.init(width: 100, height: 100)))
//   }

class VC: UIViewController {
   override func loadView() {
      view = historyModel.view
      // view.backgroundColor = .red
   }
}

let vc = VC()
nc.viewControllers = [vc]

final class BadgeModel: BaseViewModel<PaddingLabel> {
   override func start() {
      set(.text("Hello"))
      set(.zPosition(1000))
      set(.backColor(.yellow))
      view.clipsToBounds = true
      view.layer.masksToBounds = true
      view.setNeedsLayout()
      view.setNeedsDisplay()
      view.layoutSubviews()
   }
}

extension BadgeModel: Stateable2 {
   typealias State = LabelState
   typealias State2 = ViewState
}

struct HistoryViewEvent: InitProtocol {}

let historyModel = HistoryViewModel<ProductionAsset>()
final class HistoryViewModel<Asset: AssetProtocol>: BaseViewModel<UIStackView>,
   Communicable,
   Stateable,
   Assetable
{
   typealias State = StackState

   var eventsStore: HistoryViewEvent = .init()

   // MARK: - View Models

   private lazy var tableModel = TableViewModel()
      .set(.borderColor(.gray))
      .set(.borderWidth(1))
      .set(.cornerRadius(Design.Parameters.cornerRadius))

   // MARK: - Frame Cells

   // MARK: - Services

   private lazy var getTransactionsUseCase = Asset.apiUseCase.getTransactions.work()

   // Combos<SComboM<LabelModel>

   private let tetsLabel = LabelModel()
      .set(.text("TestLabel"))
   private let combo = ComboMRD()
   private let badgedTextField = BadgedModel<LabelModel, Asset>()
      .mainModel
      .set(.text("BODY"))
//      .set(.height(40))
//      .set(.size(.square(50)))
//      .set(.backColor(.random))

   override func start() {
      set(.alignment(.fill))
      set(.axis(.vertical))
      set(.models([
         Spacer(300),
         badgedTextField,
         Spacer(16),
         combo,
         Spacer(16),
         Spacer()
      ]))

      print("\nComboVIeW: ", badgedTextField.view)
   }
}

// cменить дизайн
// бизнес логику изолировать

final class ComboMRD: Combos<SComboMRD<LabelModel, LabelModel, LabelModel>> {
   override func start() {
      print("\n########### START\n")
      setMain { (model: LabelModel) in
         model
            .set(.size(.square(100)))
            .set(.backColor(.random))
            .set(.text("MAIN"))
      } setRight: { (model: LabelModel) in
         model
            //   .set(.size(.square(40)))
            .set(.backColor(.random))
            .set(.text("SECOND"))
      } setDown: { (model: LabelModel) in
         model
            .set(.backColor(.random))
            .set(.text("THIRD"))
      }
   }
}

extension ComboMRD: Stateable {
   typealias State = ViewState
}

enum BadgeState {
   case `default`(String)
   case error(String)
}

class BadgedModel<VM: VMPS, Asset: AssetProtocol>: BaseViewModel<UIStackView>, Assetable {

   let mainModel: VM = .init()
   

   let topModel: LabelModel = .init()
      .set(.text("Title label"))
      .set(.font(Design.font.caption))
   //  .set(.hidden(true))
   let downModel: LabelModel = .init()
      .set(.text("Error label"))
      .set(.font(Design.font.caption))

   override func start() {
      set(.models([topModel, mainModel, downModel]))
   }
   //  .set(.hidden(true))
}

//extension BadgedModel: ComboTop, ComboDown {
//   typealias T = LabelModel
//   typealias D = LabelModel
//}

extension BadgedModel: Stateable {
   typealias State = StackState
}

extension BadgedModel {
//   private func changeState(to badgeState: BadgeState) where VM.State == ViewState {
//      switch badgeState {
//      case .default:
//         downModel
//            .set(.hidden(true))
//         topModel
//            .set(.color(.black))
//        // set(.borderColor(.lightGray.withAlphaComponent(0.4)))
//      case .error:
//         downModel
//            .set(.hidden(false))
//            .set(.color(Design.color.errorColor))
//         topModel
//            .set(.color(Design.color.errorColor))
//        // set(.borderColor(Design.color.errorColor))
//      }
//   }
}
