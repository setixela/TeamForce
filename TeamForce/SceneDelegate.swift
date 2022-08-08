//
//  SceneDelegate.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 17.06.2022.
//

import ReactiveWorks
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
   var window: UIWindow?

   func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      guard let windowScene = (scene as? UIWindowScene) else { return }

      let window = UIWindow(windowScene: windowScene)
      let nc = UINavigationController(nibName: nil, bundle: nil)

      startDispatcher(nc)

      window.rootViewController = nc
      self.window = window
      window.makeKeyAndVisible()
   }

   func sceneDidDisconnect(_ scene: UIScene) {}
   func sceneDidBecomeActive(_ scene: UIScene) {}
   func sceneWillResignActive(_ scene: UIScene) {}
   func sceneWillEnterForeground(_ scene: UIScene) {}
   func sceneDidEnterBackground(_ scene: UIScene) {}
}

private extension SceneDelegate {
   func startDispatcher(_ nc: UINavigationController) {
      ProductionAsset.router?
         .onEvent(\.push) { vc in
            nc.pushViewController(vc, animated: true)
         }
         .onEvent(\.pop) {
            nc.popViewController(animated: true)
         }
         .onEvent(\.popToRoot) {
            nc.popToRootViewController(animated: true)
         }
         .onEvent(\.present) { vc in
            nc.viewControllers = [vc]
         }

//      ProductionAsset.router?.route(\.playground, navType: .push, payload: ())

      if UserDefaults.standard.isLoggedIn() {
         ProductionAsset.router?.route(\.main, navType: .push, payload: ())
      } else {
         ProductionAsset.router?.route(\.digitalThanks, navType: .push, payload: ())
      }
   }
}
