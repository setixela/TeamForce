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
   case present
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
         route(\.login, navType: .push, payload: ())
      } else {
         if UserDefaults.standard.isLoggedIn() {
            route(\.main, navType: .push, payload: ())
         } else {
            route(\.digitalThanks, navType: .push, payload: ())
         }
      }
   }

   func route(_ keypath: KeyPath<Scene, SceneModelProtocol>, navType: NavType, payload: Any? = nil) {
      switch navType {
      case .push:
         nc.pushViewController(makeVC(), animated: true)
      case .pop:
         nc.popViewController(animated: true)
      case .popToRoot:
         nc.popToRootViewController(animated: true)
      case .present:
         nc.viewControllers = [makeVC()]
      case .presentModally(let value):
         let vc = makeVC()
         vc.modalPresentationStyle = value
         nc.present(vc, animated: true)
      }

      // local func
      func makeVC() -> UIViewController {
         let sceneModel = Scene()[keyPath: keypath]
         sceneModel.setInput(payload)
         let vc = sceneModel.makeVC()
         return vc
      }
   }
}
