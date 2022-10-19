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
}

final class MainRouter<Asset: AssetProtocol>: RouterProtocol, Assetable {
   let nc: UINavigationController

   init(nc: UINavigationController) {
      self.nc = nc
   }

   func start() {
      if Config.isDebug {
         route(.push, scene: \.login, payload: ())
      } else {
         if UserDefaults.standard.isLoggedIn() {
            route(.push, scene: \.main, payload: ())
         } else {
            route(.push, scene: \.digitalThanks, payload: ())
         }
      }
   }

   func route(_ navType: NavType,
              scene: KeyPath<Scene, SceneModelProtocol>? = nil,
              payload: Any? = nil,
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

//   @available(*, deprecated, message: """
//   USE: func route(_ navType: NavType,
//                  scene: KeyPath<Scene, SceneModelProtocol>,
//                  payload: Any? = nil) -> Work<Bool, Bool>
//   """)
//   func route(_ keypath: KeyPath<Scene, SceneModelProtocol>,
//              navType: NavType,
//              payload: Any? = nil)
//   {
//      let work = VoidWorkVoid()
//
//      switch navType {
//      case .push:
//         nc.pushViewController(makeVC(work), animated: true)
//      case .pop:
//         nc.popViewController(animated: true)
//      case .popToRoot:
//         nc.popToRootViewController(animated: true)
//      case .presentInitial:
//         nc.viewControllers = [makeVC(work)]
//      case .presentModally(let value):
//         let vc = makeVC(work)
//         vc.modalPresentationStyle = value
//         nc.present(vc, animated: true)
//      }
//
//      // local func
//      func makeVC(_ work: VoidWorkVoid) -> UIViewController {
//         let sceneModel = Scene()[keyPath: keypath]
//         sceneModel.setInput(payload)
//         let vc = sceneModel.makeVC()
//
//         return vc
//      }
//   }
}

protocol Alert {}

protocol AlertPresenter {
   func presentAlert(_ alert: Alert, on model: UIViewModel)
}
