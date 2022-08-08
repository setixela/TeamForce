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
      view.backgroundColor = .red
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

   override func start() {
      set(.models([tableModel]))

      let models = (0 ..< 100).map { index in
         LogoTitleSubtitleModel()
            .set(.image(Design.icon.make(\.checkCircle)))
            .rightModel
                  .set(.text(String(index)))
                  .downModel
                     .set(.text("Helllo"))
      }

      tableModel
         .set(.backColor(.gray))
         .set(.models(models))

      print("transactions started")
      getTransactionsUseCase
         .doAsync()
         .onSuccess { transactions in
            print(transactions)
         }
         .onFail {
            print("transactions not loaded")
         }
   }
}


// MARK: - Todo

// public protocol TargetViewProtocol: UIView {
//    associatedtype TargetView: UIView
//
//    var targetView: TargetView { get }
// }
//
// final class TargetViewModel<TVM: ViewModelProtocol>: BaseViewModel<TVM.View> {
//    lazy var targetModel = TVM()
//
//    override func start() {}
// }
//
// final class TargetView<View: UIView>: UIView, TargetViewProtocol {
//    lazy var targetView: View = {
//        let view = View()
//        self.addSubview(view)
//        return view
//    }()
//
//    typealias TargetView = View
// }
