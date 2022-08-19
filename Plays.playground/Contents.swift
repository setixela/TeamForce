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

protocol StateProtocol {}
struct Grouper<T> {

   @discardableResult
   func set(_ value: T) -> Self {
      return self
   }

   var next: T.Type {
      return T.self
   }
}

extension StateProtocol {
   static func group(@TestBuilder _ content: () -> [Self]) ->  [Self] {
      content()
   }

  // private static var group: [Self] = []
//   static var group: Grouper<Self> {
//      return Grouper<Self>()
//   }

   static var next: Self.Type {
//      let arr = [Self]()
//
//      let
      Self.self
   }

   var next: Self.Type {
    //  let key = self.hashValue
      Self.self
   }

//   func finishGroup() -> [Self] {
//      let result = group
//      return group
//   }
}

protocol HashableExtra: Hashable {}

extension HashableExtra {

   var caseName: String {
      Mirror(reflecting: self).children.first?.label ?? String(describing: self)
   }

   func hash(into hasher: inout Hasher) {
      hasher.combine(caseName)
   }
}

extension HashableExtra {
   static func == (lhs: Self, rhs: Self) -> Bool {
      lhs.hashValue == rhs.hashValue
   }
}
//StackState
//   .next.alignment(.center)
//   .next.distribution(.fill)
//   .next.axis(.vertical)
//   .next.distribution(.fill)
//   .next.axis(.vertical)
//   .finishGroup()

@resultBuilder
struct TestBuilder {
   static func buildBlock(_ components: StateProtocol...) -> [StateProtocol] {
      return components
   }

}

func build(@TestBuilder _ content: () -> [StateProtocol]) -> [StateProtocol] {
   content()
}

@resultBuilder
struct TestBuilderConcrete {
   static func buildBlock(_ components: StackState...) -> [StackState] {
      return components
   }
}

func buildConcret(@TestBuilderConcrete _ content: () -> [StackState]) -> [StackState] {
   content()
}

//func text(_ value: StackState) -> StackState {
//   return value
//}

protocol InitNoname: InitProtocol {
   associatedtype T

   var value: T { get set }
}

extension InitNoname {

   init(_ value: T) {
      self.init()
      self.value = value
   }
}

struct text: StateProtocol, InitNoname {
   var value: String = "" // default
}

struct align: StateProtocol, InitNoname {
   var value: UIStackView.Alignment = .center // default
}

let value = build {
   text("hello")
   align(.center)
}



StackState.distribution(.fill)
StackState.axis(.vertical)
StackState.distribution(.fill)


//StackState.group
//   .set(.height(10))
//   .set(.distribution(.fill))
//   .set(.axis(.vertical))
//   .set(.distribution(.fill))
//   .set(.axis(.vertical))
//
print(value)

//

enum StackState: StateProtocol, HashableExtra {
   case distribution(StackViewExtended.Distribution)
   case axis(NSLayoutConstraint.Axis)
   case spacing(CGFloat)
   case alignment(StackViewExtended.Alignment)
   case padding(UIEdgeInsets)
   case backColor(UIColor)
   case cornerRadius(CGFloat)
   case borderWidth(CGFloat)
   case borderColor(UIColor)
   case height(CGFloat)
   case models([UIViewModel])
   case hidden(Bool)
   case backView(UIView, inset: UIEdgeInsets = .zero)
   case backImage(UIImage)
   case backViewModel(UIViewModel, inset: UIEdgeInsets = .zero)
   case shadow(Shadow)
}

enum LabelState: StateProtocol, HashableExtra {
   case text(String)
   case font(UIFont)
   case color(UIColor)
   case numberOfLines(Int)
   case alignment(NSTextAlignment)
   // Padding
   case padding(UIEdgeInsets)
   case padLeft(CGFloat)
   case padRight(CGFloat)
   case padUp(CGFloat)
   case padBottom(CGFloat)
}

protocol Params {}

example {

   enum ParamsA: Params {
      case param1
      case param2
   }

   func makeParams() -> Params {
      ParamsA.param1
   }

   let params = makeParams()

   log(params)

   func makeSomeParams() -> Params {
      ParamsA.param1
   }

   func makeInt() -> some Equatable {
      10
   }
}


public typealias InitHashable = Hashable & InitProtocol

enum UnsafeHashableTemper {
   private static var storage: [Int: Any] = [:]

   @discardableResult
   static func initStore<T: InitHashable>(for key: Int) -> T {
      let new = T.init()

      DispatchQueue.main.async {
         storage[key] = new
      }

      return new
   }

   static func store<T: InitHashable>(for key: Int) -> T {

      guard let value = storage[key] as? T else {
         fatalError()
      }

      return value
   }

   static func clearStore(for key: Int) {
      storage[key] = nil
   }
}

let asdas = ["a","N"].hashValue
