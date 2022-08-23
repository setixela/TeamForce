//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import ReactiveWorks
import UIKit

func example(_ name: String = "", action: () -> Void) {
   print("\n--- Example \(name):")
   action()
}

if true {
   let nc = UINavigationController()
   nc.view.frame = CGRect(x: 0, y: 0, width: 360, height: 640)
   PlaygroundPage.current.liveView = nc

   ///////// """ STATEABLE -> PARAMETRIC """

   ///// MARK: - СДЕЛАТЬ АНИМАЦИЮ ПОЯВЛЕНИЯ БЛОКОВ

   class VC: UIViewController {
      override func loadView() {
//         view = scene.makeMainView()
//         view = UIView()
         view = model.uiView
      }
   }

   let vc = VC()
   nc.viewControllers = [vc]
} else {
   PlaygroundPage.current.needsIndefiniteExecution = true
}

// let scene = MainScene<ProductionAsset>()
let model = FeedScene<ProductionAsset>()

// MARK: - Experiments --------------------------------------------------------------
final class FeedScene<Asset: AssetProtocol>: BaseViewModel<StackViewExtended>, Assetable, Stateable2 {
   typealias State = ViewState
   typealias State2 = StackState

   private lazy var feedTableModel = TableItemsModel<Design>()
      .set_backColor(Design.color.background)

   private lazy var useCase = Asset.apiUseCase

   override func start() {
      set_axis(.vertical)
      set_arrangedModels([
         Grid.x16.spacer,
         feedTableModel,
         //Spacer(88),
      ])

//      useCase.getFeed.work
//         .retainBy(useCase.retainer)
//         .doAsync()
//         .onSuccess {
//            log($0)
//         }
//         .onFail {
//            errorLog("Feed load API ERROR")
//         }
   }

   lazy var feedCellPresenter: Presenter<Feed, ViewModel> = Presenter<Feed, ViewModel> { work in


      let comboMR = Combos<SComboMR<ImageViewModel, ViewModel>>()
         .setAll { avatar, infoBlock in

         }
   }
}
