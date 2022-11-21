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
      let nc = NavController(nibName: nil, bundle: nil)

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
   func startDispatcher(_ nc: NavController) {
      let brandColor = ProductionAsset.Design.color.backgroundBrand
      let backBrightness = brandColor.brightnessStyle()

      switch backBrightness {
         case .dark:
            nc
               .barStyle(.black)
               .titleColor(ProductionAsset.Design.color.iconInvert)
               .navBarTintColor(ProductionAsset.Design.color.iconInvert)
               .statusBarStyle(.lightContent)
         case .light:
            nc
               .barStyle(.default)
               .titleColor(ProductionAsset.Design.color.textBrand)
               .navBarTintColor(ProductionAsset.Design.color.textBrand)
               .statusBarStyle(.darkContent)
      }

      router = ProductionAsset.makeRouter(with: nc)
      window?.backgroundColor = ProductionAsset.Design.color.backgroundBrand
      router?.start()
   }
}

extension AssetProtocol {
   static func makeRouter(with nc: NavController) -> RouterProtocol {
      let router = MainRouter<Asset>(nc: nc)
      self.router = router
      return router
   }
}

final class NavController: UINavigationController {
   private var currentStatusBarStyle: UIStatusBarStyle?

   override var preferredStatusBarStyle: UIStatusBarStyle {
      if let vc = visibleViewController as? any VCModelProtocol {
         return vc.currentStatusBarStyle ?? currentStatusBarStyle ?? .default
      } else {
        return currentStatusBarStyle ?? .default
      }
   }
}

extension NavController {
   @discardableResult func barStyle(_ value: UIBarStyle) -> Self {
      navigationBar.barStyle = value
      return self
   }

   @discardableResult func navBarTintColor(_ value: UIColor) -> Self {
      navigationBar.barTintColor = value
      navigationBar.tintColor = value
      return self
   }

   @discardableResult func statusBarStyle(_ value: UIStatusBarStyle) -> Self {
      currentStatusBarStyle = value
      setNeedsStatusBarAppearanceUpdate()
      return self
   }

   @discardableResult func titleColor(_ value: UIColor) -> Self {
      let textAttributes = [NSAttributedString.Key.foregroundColor: value]
      navigationBar.titleTextAttributes = textAttributes
      return self
   }
}
