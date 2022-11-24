//
//  Router.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 03.06.2022.
//

import UIKit

import ReactiveWorks

enum NavType {
   case push
   case presentInitial
   case pop
   case popToRoot
   case presentModally(UIModalPresentationStyle)
   case presentModallyOnPresented(UIModalPresentationStyle)
}

final class MainRouter<Asset: AssetProtocol>: RouterProtocol, Assetable {
   let nc: UINavigationController

   init(nc: UINavigationController) {
      self.nc = nc
      nc.view.backgroundColor = Design.color.backgroundBrand
      initColors()
   }

   func start() {
      if Config.isPlaygroundScene {
         route(.push, scene: \.login, payload: ())
      } else {
         if UserDefaults.standard.isLoggedIn() {
            route(.push, scene: \.main, payload: ())
         } else {
            route(.push, scene: \.digitalThanks, payload: ())
         }
      }
   }

   func route<In, T: BaseScene<In> & SMP>(_ navType: NavType,
                                          scene: KeyPath<Scene, T>? = nil,
                                          payload: T.Input? = nil,
                                          finisher: GenericClosure<Bool>? = nil)
   {
      switch navType {
      case .push:
         nc.pushViewController(makeVC(), animated: true)
      case .pop:
         nc.popViewController(animated: true)
      case .popToRoot:
         nc.popToRootViewController(animated: true)
      case .presentInitial:
         nc.viewControllers = [makeVC()]
      case .presentModally(let value):
         let vc = makeVC()
         vc.modalPresentationStyle = value
         nc.present(vc, animated: true)
      case .presentModallyOnPresented(let value):
         let vc = makeVC()
         vc.modalPresentationStyle = value
         if let presented = nc.presentedViewController {
            presented.present(vc, animated: true)
         } else {
            nc.present(vc, animated: true)
         }
      }

      // local func
      func makeVC() -> UIViewController {
         guard let scene else {
            assertionFailure()
            return .init()
         }

         let sceneModel = Scene()[keyPath: scene]
         sceneModel.setInput(payload)
         let vc = sceneModel.makeVC()

         if let finisher {
            let wrapped = { (result: Bool) in
               finisher(result)
               sceneModel.finisher = nil
            }

            sceneModel.finisher = wrapped
         }

         return vc
      }
   }

   func initColors() {
      guard let nc = nc as? NavController else { return }

      let brandColor = ProductionAsset.Design.color.backgroundBrand
      let backBrightness = brandColor.brightnessStyle()

      nc.barBackColor(ProductionAsset.Design.color.transparent)
         .barTranslucent(true)
         .titleAlpha(1)

      switch backBrightness {
      case .dark:
         nc.barStyle(.black)
            .titleColor(ProductionAsset.Design.color.iconInvert)
            .navBarTintColor(ProductionAsset.Design.color.iconInvert)
            .statusBarStyle(.lightContent)
      case .light:
         nc.barStyle(.default)
            .titleColor(ProductionAsset.Design.color.textBrand)
            .navBarTintColor(ProductionAsset.Design.color.textBrand)
            .statusBarStyle(.darkContent)
      }
   }

//   func route(_ navType: NavType,
//              scene: KeyPath<Scene, SceneModelProtocol>? = nil,
//              payload: Any? = nil,
//              finisher: GenericClosure<Bool>? = nil)
//   {
//      switch navType {
//      case .push:
//         nc.pushViewController(makeVC(), animated: true)
//      case .pop:
//         nc.popViewController(animated: true)
//      case .popToRoot:
//         nc.popToRootViewController(animated: true)
//      case .presentInitial:
//         nc.viewControllers = [makeVC()]
//      case .presentModally(let value):
//         let vc = makeVC()
//         vc.modalPresentationStyle = value
//         nc.present(vc, animated: true)
//      case .presentModallyOnPresented(let value):
//         let vc = makeVC()
//         vc.modalPresentationStyle = value
//         nc.presentedViewController?.present(vc, animated: true)
//      }
//
//      // local func
//      func makeVC() -> UIViewController {
//         guard let scene else {
//            assertionFailure()
//            return .init()
//         }
//
//         let sceneModel = Scene()[keyPath: scene]
//         sceneModel.setInput(payload)
//         let vc = sceneModel.makeVC()
//
//         if let finisher {
//            let wrapped = { (result: Bool) in
//               finisher(result)
//               sceneModel.finisher = nil
//            }
//
//            sceneModel.finisher = wrapped
//         }
//
//         return vc
//      }
//   }
}

extension MainRouter {
   private var currentVC: UIViewController? { nc.viewControllers.last }
}

protocol Alert {}

protocol AlertPresenter {
   func presentAlert(_ alert: Alert, on model: UIViewModel)
}
