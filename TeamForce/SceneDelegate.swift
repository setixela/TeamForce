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

   var router: RouterProtocol?

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
      nc.navigationBar.tintColor = .white
      router = ProductionAsset.makeRouter(with: nc)
      router?.start()
   }
}

extension AssetProtocol {
   static func makeRouter(with nc: UINavigationController) -> RouterProtocol {
      let router = MainRouter<Asset>(nc: nc)
      self.router = router
      return router
   }
}

