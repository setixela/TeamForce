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
         view = MyViewModel().view
         // view = historyModel.makeMainView()
      }
   }

   let vc = VC()
   nc.viewControllers = [vc]
} else {
   PlaygroundPage.current.needsIndefiniteExecution = true
}

let historyModel = TestScene<ProductionAsset>()

final class TestScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   TripleStacksBrandedVM<Asset.Design>,
   Asset,
   Void
> {
   let panelBack = ImageViewModel()
      .set_image(Asset.Design.icon.bottomPanel)

   // MARK: - View Models

   override func start() {
      mainVM.footerStack
         // .set_models([panelBack])

         .set_axis(.horizontal)
         .set_distribution(.equalCentering)
         .set_alignment(.bottom)
         .set_models([
            Grid.xxx.spacer,
            ButtonModel()
               .set_image(Design.icon.tabBarMainButton)
               .set_size(.square(60))
            // .set_padding(.verticalShift(36))
            ,
            Grid.xxx.spacer
         ])
         .set_padding(.verticalShift(36))
         .set_height(88)
         .set_shadow(.init(radius: 8, color: Design.color.iconContrast, opacity: 0.13)
)

//         .set_backImage(Asset.Design.icon.bottomPanel, contentMode: .scaleToFill)
   }
}

final class TripleStacksBrandedVM<Design: DesignProtocol>:
   Combos<SComboMDD<StackModel, WrappedY<StackModel>, WrappedY<StackModel>>>,
   Designable
{
   lazy var header = Design.label.headline5
      .set_color(Design.color.textInvert)

   var headerStack: StackModel { models.main }
   var bodyStack: StackModel { models.down.subModel }
   var footerStack: StackModel { models.down2.subModel }

   required init() {
      super.init()

      set_backColor(.lightGray)
      setMain {
         $0
            .set(Design.state.stack.default)
            .set_backColor(Design.color.backgroundBrand)
            .set_alignment(.leading)
            .set_models([
               Grid.x16.spacer,
               BrandLogoIcon<Design>(),
               Grid.x16.spacer,
               header,
               Grid.x36.spacer
            ])
      } setDown: {
         $0
            //            .set(Design.state.stack.bottomShadowedPanel)
            .set_backColor(Design.color.background)
            .set_padding(.top(-Grid.x16.value))
            .set_padBottom(-Grid.x64.value)
            .subModel
            .set(Design.state.stack.bottomShadowedPanel)
      } setDown2: {
         print($0.view.layoutMargins)
         $0
        //    .set_backColor(.red)
            .set_backImage(Design.icon.bottomPanel, contentMode: .scaleToFill)
//            .set_height(100)

         //            .set(Design.state.stack.bottomShadowedPanel)
//           .set_backColor(Design.color.transparent)
          // .set_padding(.top(Grid.x16.value))
            .set_shadow(.init(radius: 8, color: Design.color.iconContrast, opacity: 0.13))
         //    .set_padBottom(-Grid.x32.value)

         // .set_height(300)
         // .set_backImage(Design.icon.bottomPanel, contentMode: .scaleToFill)
         //  .subModel
         // .set(Design.state.stack.bottomShadowedPanel)
      }
   }
}
