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

   //
   //
   //
   //

   //
   //
   //
   //

   //
   //
   //
   //

   //
   //
   //
   //
   //
   //
   //
   //
   //
   //
   //
   //

   override func start() {
      let combo = Combos { (model: LabelModel) in
         model
            .set(.backColor(.random))
            .set(.text("MAIN"))
      } setRight: { (model: LabelModel) in
         model
            .set(.backColor(.random))
            .set(.text("SECOND"))
      }

      combo
         .set(\.main) {
            $0.set(.text("no main he he"))
         }.set(\.right) {
            $0.set(.text("HAHAHAHAHA"))
         }

      let combo2 = Combos { (model: LabelModel) in
         model
            .set(.backColor(.random))
            .set(.text("MAIN"))
      } setDown: { (model: LabelModel) in
         model
            .set(.backColor(.random))
            .set(.text("SECOND"))
      }

      let combo3 = Combos { (model: LabelModel) in
         model
            .set(.backColor(.random))
            .set(.text("MAIN"))
      } setDown: { (model: LabelModel) in
         model
            .set(.backColor(.random))
            .set(.text("SECOND"))
      } setDown2: { (model: LabelModel) in
         model
            .set(.backColor(.random))
            .set(.text("THIRD"))
      }

      set(.alignment(.leading))
      set(.axis(.vertical))
      set(.models([
         combo,
         Spacer(16),
         combo2,
         Spacer(16),
         combo3,
         Spacer()
      ]))
   }
}
