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

   private let combo = ComboMRD()
   private let badgedModel = BadgedViewModel<ComboMRD, Asset>()
      .onModeChanged(\.error) { model in
         [model?.topModel, model?.downModel].forEach {
            $0?.set(.color(Asset.Design.color.errorColor))
         }
      }
      .onModeChanged(\.normal) { model in
         [model?.topModel, model?.downModel].forEach {
            $0?.set(.color(Asset.Design.color.textPrimary))
         }
      }
//     .setMode(\.normal)

   override func start() {
      set(.alignment(.leading))
      set(.axis(.vertical))
      set(.models([
         Spacer(160),
         badgedModel,
         Spacer(64),
         combo,
         Spacer(16),
         Spacer()
      ]))
   }
   //  .set(.hidden(true))
}

// cменить дизайн
// бизнес логику изолировать



