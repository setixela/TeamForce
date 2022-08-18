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
         view = scene.makeMainView()
      }
   }

   let vc = VC()
   nc.viewControllers = [vc]
} else {
   PlaygroundPage.current.needsIndefiniteExecution = true
}

let scene = MainScene<ProductionAsset>()

// MARK: - Experiments --------------------------------------------------------------

final class MainScene<Asset: AssetProtocol>:
   BaseSceneModel<
      DefaultVCModel,
      TripleStacksBrandedVM<Asset.Design>,
      Asset,
      Void
   >
{
   lazy var balanceViewModel = BalanceViewModel<Asset>()
   lazy var transactViewModel = TransactScene<Asset>()
   lazy var historyViewModel = HistoryScene<Asset>()

   var tabBarPanel: TabBarPanel<Design> { mainVM.footerStack }

   // MARK: - Side bar

   private let sideBarModel = SideBarModel<Asset>()
   private let menuButton = BarButtonModel()

   // MARK: - Start

   override func start() {
      sideBarModel.start()

      mainVM.header.set_text("Баланс")

      menuButton
         .sendEvent(\.initWithImage, Design.icon.sideMenu)

      presentModel(balanceViewModel)

      tabBarPanel.button1
         .onEvent(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.set_text("Пока пусто")
            self?.tabBarPanel.button1.setMode(\.normal)
         }

      tabBarPanel.button2
         .onEvent(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.set_text("Баланс")
            self?.presentModel(self?.balanceViewModel)
            self?.tabBarPanel.button2.setMode(\.normal)
         }

      tabBarPanel.buttonMain
         .onEvent(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.set_text("Тра")
            self?.presentModel(self?.transactViewModel)
            self?.tabBarPanel.button2.setMode(\.normal)
         }

      tabBarPanel.button3
         .onEvent(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.set_text("История")
            self?.presentModel(self?.historyViewModel)
            self?.tabBarPanel.button3.setMode(\.normal)
         }

      tabBarPanel.button4
         .onEvent(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.set_text("Пока пусто")
            self?.tabBarPanel.button4.setMode(\.normal)
         }

      //      menuButton
      //         .onEvent(\.initiated) { [weak self] item in
      //            self?.vcModel?.sendEvent(\.setLeftBarItems, [item])
      //         }
      //         .onEvent(\.didTap) { [weak self] in
      //            guard let self = self else { return }
      //
      //            self.sideBarModel.sendEvent(\.presentOnScene, self.mainVM.view)
      //         }

      configureSideBarItemsEvents()
      //   mainVM.uiView.layoutSubviews()
   }

   private func unlockTabButtons() {
      tabBarPanel.button1.setMode(\.inactive)
      tabBarPanel.button2.setMode(\.inactive)
      tabBarPanel.button3.setMode(\.inactive)
      tabBarPanel.button4.setMode(\.inactive)
   }

   private func configureSideBarItemsEvents() {
      weak var weakSelf = self

      sideBarModel.item1
         .onEvent(\.didTap) {
            weakSelf?.sideBarModel.sendEvent(\.hide)
            weakSelf?.presentModel(weakSelf?.balanceViewModel)
         }

      sideBarModel.item2
         .onEvent(\.didTap) {
            weakSelf?.sideBarModel.sendEvent(\.hide)
            weakSelf?.presentModel(weakSelf?.transactViewModel)
         }

      sideBarModel.item3
         .onEvent(\.didTap) {
            weakSelf?.sideBarModel.sendEvent(\.hide)
            weakSelf?.presentModel(weakSelf?.historyViewModel)
         }
   }
}

extension MainScene {
   private func presentModel(_ model: UIViewModel?) {
      guard let model = model else { return }

      mainVM.bodyStack
         .set_models([
            model
         ])
   }
}

final class TabBarBackImageModel<Design: DSP>: BaseViewModel<PaddingImageView>, Designable, Stateable2 {
   typealias State = ImageViewState
   typealias State2 = ViewState

   override func start() {
      set_image(Design.icon.bottomPanel)
      set_imageTintColor(Design.color.background)
      set_shadow(Design.params.panelShadow)
   }
}

// MARK: - View Models --------------------------------------------------------------

final class TripleStacksBrandedVM<Design: DesignProtocol>:
   Combos<SComboMDD<StackModel, WrappedY<StackModel>, WrappedSubviewY<TabBarPanel<Design>>>>,
   Designable
{
   lazy var header = Design.label.headline5
      .set_color(Design.color.textInvert)

   var headerStack: StackModel { models.main }
   var bodyStack: StackModel { models.down.subModel }
   var footerStack: TabBarPanel<Design> { models.down2.subModel }

   required init() {
      super.init()

      setMain {
         $0
            .set(Design.state.stack.header)
            .set_alignment(.leading)
            .set_models([
               Grid.x1.spacer,
               BrandLogoIcon<Design>(),
               Grid.x16.spacer,
               header,
               Grid.x36.spacer
            ])
      } setDown: {
         $0
            .set_backColor(Design.color.background)
            .set_padding(.top(-Grid.x16.value))
            .set_padBottom(-88)
            .subModel
            .set(Design.state.stack.bodyStack)
      } setDown2: { _ in }
   }
}

// MARK: - -----------------

final class TabBarPanel<Design: DesignProtocol>: BaseViewModel<StackViewExtended>, Designable, Stateable {
   typealias State = StackState

   // MARK: - View Models

   let button1: ButtonModel = BottomPanelVMBuilder<Design>.button
      .set_image(Design.icon.tabBarButton1)
   let button2: ButtonModel = BottomPanelVMBuilder<Design>.button
      .set_image(Design.icon.tabBarButton2)

   let buttonMain: ButtonModel = BottomPanelVMBuilder<Design>.mainButton

   let button3: ButtonModel = BottomPanelVMBuilder<Design>.button
      .set_image(Design.icon.tabBarButton3)
   let button4: ButtonModel = BottomPanelVMBuilder<Design>.button
      .set_image(Design.icon.tabBarButton4)

   // MARK: - Private

   private let backImage = TabBarBackImageModel<Design>()

   // MARK: - Start

   override func start() {
      set_axis(.horizontal)
         .set_distribution(.equalSpacing)
         .set_alignment(.bottom)
         .set_models([
            Grid.xxx.spacer,
            button1,
            button2,

            WrappedY(
               buttonMain
            )
            .set_padding(.verticalShift(30)),
            button3,
            button4,
            Grid.xxx.spacer
         ])

         .set_padding(.verticalShift(11))
         .set_height(97)
         .set_backViewModel(backImage)
   }
}

struct BottomPanelVMBuilder<Design: DesignProtocol>: Designable {
   static var mainButton: ButtonModel {
      ButtonModel()
         .set_image(Design.icon.tabBarMainButton)
         .set_size(.square(60))
         .set_shadow(Design.params.panelMainButtonShadow)
   }

   static var button: ButtonModel {
      ButtonModel()
         .set_width(55)
         .set_height(46)
         .set_cornerRadius(16)
         .onModeChanged(\.normal) { button in
            log("sh")
            button?
               .set_backColor(Design.color.backgroundBrandSecondary)
               .set_shadow(Design.params.panelButtonShadow)
            button?.uiView.layoutIfNeeded()
         }
         .onModeChanged(\.inactive) { button in
            button?
               .set_backColor(Design.color.transparent)
               .set_shadow(.noShadow)
         }
         .setMode(\.inactive)
   }
}
