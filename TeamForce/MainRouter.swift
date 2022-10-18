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

   @discardableResult
   func route(_ navType: NavType,
              scene: KeyPath<Scene, SceneModelProtocol>? = nil,
              payload: Any? = nil) -> Work<Void, Void>
   {
      let work = Work<Void, Void> { work in
         work.success(work.unsafeInput)
      }

      switch navType {
      case .push:
         nc.pushViewController(makeVC(work), animated: true)
      case .pop:
         nc.popViewController(animated: true)
      case .popToRoot:
         nc.popToRootViewController(animated: true)
      case .presentInitial:
         nc.viewControllers = [makeVC(work)]
      case .presentModally(let value):
         let vc = makeVC(work)
         vc.modalPresentationStyle = value
         nc.present(vc, animated: true)
      }

      // local func
      func makeVC(_ work: Work<Void, Void>) -> UIViewController {
         guard let scene else {
            assertionFailure()
            return .init()
         }

         let sceneModel = Scene()[keyPath: scene]
         sceneModel.setInput(payload)
         let vc = sceneModel.makeVC()

         sceneModel.finisher = work

         return vc
      }

      return work
   }

   @available(*, deprecated, message: """
   USE: func route(_ navType: NavType,
                  scene: KeyPath<Scene, SceneModelProtocol>,
                  payload: Any? = nil) -> Work<Bool, Bool>
   """)
   @discardableResult
   func route(_ keypath: KeyPath<Scene, SceneModelProtocol>,
              navType: NavType,
              payload: Any? = nil) -> VoidWorkVoid {
      let work = VoidWorkVoid()

      switch navType {
      case .push:
         nc.pushViewController(makeVC(work), animated: true)
      case .pop:
         nc.popViewController(animated: true)
      case .popToRoot:
         nc.popToRootViewController(animated: true)
      case .presentInitial:
         nc.viewControllers = [makeVC(work)]
      case .presentModally(let value):
         let vc = makeVC(work)
         vc.modalPresentationStyle = value
         nc.present(vc, animated: true)
      }

      // local func
      func makeVC(_ work: VoidWorkVoid) -> UIViewController {
         let sceneModel = Scene()[keyPath: keypath]
         sceneModel.setInput(payload)
         let vc = sceneModel.makeVC()

         sceneModel.finisher = work

         return vc
      }

      return work
   }
}

protocol Alert {}

protocol AlertPresenter {
   func presentAlert(_ alert: Alert, on model: UIViewModel)
}
