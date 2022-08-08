//
//  PlaygroundScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 07.08.2022.
//

import ReactiveWorks
import UIKit

final class PlaygroundScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   StackModel,
   Asset,
   Void
> {
   override func start() {
      let viewModel = VizitkaDemo()
         .set(.size(.init(width: 150, height: 100)))

      let title = LabelModel()
         .set(.text("Hello"))
         .set(.backColor(.random))

      let titleSubtitle = TitleSubtitleModel()
         .set(.text("Hello"))
         .set(.backColor(.random))
         .setDown {
            $0
               .set(.text("World"))
               .set(.backColor(.random))
         }

      let logoTitleSubtitle = LogoTitleSubtitleModel()
         .set(.image(Design.icon.make(\.logo)))
         .set(.backColor(.random))
         .setRight {
            $0
               .set(.text("Hello"))
               .set(.backColor(.random))
               .setDown {
                  $0
                     .set(.text("World"))
                     .set(.backColor(.random))
               }
         }

      typealias VM1 = ViewModel
      typealias VM2 = ViewModel
      typealias VM3 = ViewModel
      typealias VM4 = ViewModel
      typealias VM5 = ViewModel

      /*

       let comboModel = Combinator<VM1>()
          .set(.backColor(.white))
          .setCombo {
             $0
                .setMain {
                   $0
                }.setRight {
                   $0
                }.setDown {
                   $0
                }.setRight2 {
                   $0
                }.setDown2 {
                   $0
                }
          }

        */

//      let step = Step0()
//         .setMain { (logo: ImageViewModel) in
//
//         }
//         .setRight { (title: ViewModel) in
//
//         }
//         .setDown { (subtitle: ViewModel) in
//
//         }
//         .setDown2 { (caption: ViewModel) in
//            
//         }

//      let comboModel = ComboFullModel<<#Main: ViewModelProtocol#>,
//                                      <#RightModel: ViewModelProtocol#>,
//                                      <#DownModel: ViewModelProtocol#>,
//                                      <#LeftModel: ViewModelProtocol#>,
//                                      <#TopModel: ViewModelProtocol#>>()

//      let userCombinedModel = Combinator<ViewModel>()
//         //.set(.image(.init()))
//         .setRight<LabelModel> {}
//         .setDown<LabelModel> {}

      mainViewModel
         .set(.alignment(.leading))
         .set(.axis(.vertical))
         .set(.models([
            Spacer(150),
            viewModel.set(.backColor(.white)),
            Spacer(32),
            title,
            Spacer(32),
            titleSubtitle,
            Spacer(32),
            logoTitleSubtitle,
            Spacer()
         ]))
   }
}

final class VizitkaDemo: BaseViewModel<UIView>, Stateable {
   typealias State = ViewState

   let rightModel = ViewModel()
      .set(.size(.init(width: 66, height: 100)))
      .set(.backColor(.yellow))

   let leftModel = ImageViewModel()
      .set(.size(.init(width: 100, height: 100)))
      .set(.backColor(.lightGray))
      .set(.image(ProductionAsset.Design.icon.make(\.logo)))

   let topModel = LabelModel()
      .set(.padLeft(64))
      .set(.numberOfLines(0))
      .set(.text("Full name and biography\nAnd many texts here"))
      .set(.backColor(.green))

   let downModel = ViewModel()
      .set(.height(33))
      .set(.backColor(.blue))
}

extension Combo {
   static func make() {}
}

extension VizitkaDemo: ComboRight {} // try to off this
extension VizitkaDemo: ComboLeft {} // or this
extension VizitkaDemo: ComboDown {}
extension VizitkaDemo: ComboTop {}

final class ViewModel: BaseViewModel<UIView> {}
extension ViewModel: Stateable {
   typealias State = ViewState
}

// MARK: - Right

protocol ConfiguratorProtocol: AnyObject {
   var rightModel: InitProtocol? { get set }
   var leftModel: InitProtocol? { get set }
   var topModel: InitProtocol? { get set }
   var downModel: InitProtocol? { get set }
}

// RDLT Верстка

protocol ConfigRDLT: ConfigR, ConfigD, ConfigL, ConfigT {} // case rdlu // 15
protocol ConfigRDL: ConfigR, ConfigD, ConfigL {} // case rdl // 11
protocol ConfigRDT: ConfigR, ConfigD, ConfigT {} // case rdu // 12
protocol ConfigRD: ConfigR, ConfigD {} // case rd // 5
protocol ConfigRLT: ConfigR, ConfigL, ConfigT {} // case rlu // 12
protocol ConfigRL: ConfigR, ConfigL {} // case rl // 6
protocol ConfigRT: ConfigR, ConfigT {} // case ru // 7
protocol ConfigR {} // case r // 1
protocol ConfigDLT: ConfigD, ConfigL, ConfigT {} // case dlu // 13
protocol ConfigDL: ConfigD, ConfigL {} // case dl // 8
protocol ConfigDT: ConfigD, ConfigT {} // case du // 9
protocol ConfigD {} // case d // 2
protocol ConfigLT: ConfigL, ConfigT {} // case lu // 10
protocol ConfigL {} // case l // 3
protocol ConfigT {} // case u // 4

struct Start {
   @discardableResult
   func setMain<T: VMP>(_ closure: (ComboMainModel<T>) -> Void) -> ComboMainModel<T> {
      let main = ComboMainModel<T>()
      closure(main)

      return main
   }
}

//extension ComboMainModel {
//
//   @discardableResult
//   func setRight<T: VMP>(_ closure: (T) -> Void) -> Step2R {
//      let value = T()
//      closure(value)
//
//      return Step2R(m: m, r: value)
//   }
//
//   @discardableResult
//   func setDown<T: VMP>(_ closure: (T) -> Void) -> Step2D {
//      let value = T()
//      closure(value)
//
//      return Step2D(m: m, d: value)
//   }
//}

struct Step2R {
   let m: Any
   let r: Any

   @discardableResult
   func setRight2<T: VMP>(_ closure: (T) -> Void) -> Step3RR {
      let value = T()
      closure(value)

      return Step3RR(m: m, r: r, r2: value)
   }

   @discardableResult
   func setDown<T: VMP>(_ closure: (T) -> Void) -> Step3RD {
      let value = T()
      closure(value)

      return Step3RD(m: m, r: r, d: value)
   }
}

struct Step2D {
   let m: Any
   let d: Any

   @discardableResult
   func setRight<T: VMP>(_ closure: (T) -> Void) -> Step3DR {
      let value = T()
      closure(value)

      return Step3DR(m: m, d: d, r: value)
   }

   @discardableResult
   func setDown2<T: VMP>(_ closure: (T) -> Void) -> Step3DD {
      let value = T()
      closure(value)

      return Step3DD(m: m, d: d, d2: value)
   }
}

struct Step3RR {
   let m: Any
   let r: Any
   let r2: Any

   func setDown<T: VMP>(_ closure: (T) -> Void) -> Step4RRD {
      let value = T()
      closure(value)

      return Step4RRD(m: m, r: r, r2: r2, d: value)
   }
}

struct Step3RD {
   let m: Any
   let r: Any
   let d: Any

   func setDown2<T: VMP>(_ closure: (T) -> Void) -> Step4RDD {
      let value = T()
      closure(value)

      return Step4RDD(m: m, r: r, d: d, d2: value)
   }

   func setRight2<T: VMP>(_ closure: (T) -> Void) -> Step4RRD {
      let value = T()
      closure(value)

      return Step4RRD(m: m, r: r, r2: value, d: d)
   }
}

//

struct Step3DD {
   let m: Any
   let d: Any
   let d2: Any

   func setRight<T: VMP>(_ closure: (T) -> Void) -> Step4RDD {
      let value = T()
      closure(value)

      return Step4RDD(m: m, r: value, d: d, d2: d2)
   }
}

struct Step3DR {
   let m: Any
   let d: Any
   let r: Any

   func setDown2<T: VMP>(_ closure: (T) -> Void) -> Step4RDD {
      let value = T()
      closure(value)

      return Step4RDD(m: m, r: r, d: d,  d2: value)
   }

   func setRight2<T: InitProtocol>(_ closure: (T) -> Void) -> Step4RRD {
      let value = T()
      closure(value)

      return Step4RRD(m: m, r: r, r2: value, d: d)
   }
}

struct Step4RDD {
   let m: Any
   let r: Any
   let d: Any
   let d2: Any
}

struct Step4RRD {
   let m: Any
   let r: Any
   let r2: Any
   let d: Any
}

////

extension ConfigR {
   @discardableResult
   func setRight<T: InitProtocol>(_ closure: (T) -> Void) -> Self {
      let value = T()
      closure(value)

      return self
   }
}

extension ConfigD {
   @discardableResult
   func setDown<T: InitProtocol>(_ closure: (T) -> Void) -> Self {
      let value = T()
      closure(value)

      return self
   }
}

extension ConfigL {
   @discardableResult
   func setLeft<T: InitProtocol>(_ closure: (T) -> Void) -> Self {
      let value = T()
      closure(value)

      return self
   }
}

extension ConfigT {
   @discardableResult
   func setTop<T: InitProtocol>(_ closure: (T) -> Void) -> Self {
      let value = T()
      closure(value)

      return self
   }
}

final class Configurator: ConfiguratorProtocol {
   var rightModel: InitProtocol?
   var leftModel: InitProtocol?
   var topModel: InitProtocol?
   var downModel: InitProtocol?
}

final class Combinator<Main: InitProtocol
//   Left: InitProtocol,
//   Right: InitProtocol
//   Down: InitProtocol,
   //  Up: InitProtocol
> {
   enum Cases {
      case r // 1
      case d // 2
      case l // 3
      case t // 4
      case rd // 5
      case rl // 6
      case rt // 7
      case dl // 8
      case dt // 9
      case lt // 10
      case rdl // 11
      case rdt // 12
      case rlt // 12
      case dlt // 13
      case rdlt // 15
   }

   func configure() -> Configurator {
      Configurator()
   }

//   static func configure<M: VMP, R: VMP, D: VMP, L: VMP, T: VMP>(
//      main: GenericClosure<M>? = nil,
//      right: GenericClosure<R>? = nil,
//      down: GenericClosure<D>? = nil,
//      left: GenericClosure<L>? = nil,
//      top: GenericClosure<T>? = nil
//   ) -> Combo {
//      let combo = ComboFullModel<M, R, D, L, T>()
//
////      main?(combo.mainModel)
//      right?(combo.rightModel)
//      down?(combo.downModel)
//      left?(combo.leftModel)
//      top?(combo.topModel)
//
//      return combo
//   }
//   var rightModel: Right?
//   var leftModel: Left?
//   var topModel: Up?
//   var downModel: Down?

//   @discardableResult
//   func setRight<T: InitProtocol>(_ closure: (T) -> Void) -> Self where T: Right {
//      let right = T()
//      rightModel = right
//      closure(right)
//
//      return self
//   }
}

extension UIColor {
   static var random: UIColor {
      .init(hue: .random(in: 0 ... 1), saturation: 0.3, brightness: 0.8, alpha: 1)
   }
}
