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

      nc
         .barBackColor(ProductionAsset.Design.color.transparent)
         .barTranslucent(true)
         .titleAlpha(1)

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

final class NavController: UINavigationController, UINavigationControllerDelegate {
   private var currentStatusBarStyle: UIStatusBarStyle?
   private var currentBarStyle: UIBarStyle?
   private var currentBarTintColor: UIColor?
   private var currentTitleColor: UIColor?
   private var currentBarTranslucent: Bool?
   private var currentBarBackColor: UIColor?
   private var currentTitleAlpha: CGFloat?

   override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

      delegate = self
   }

   @available(*, unavailable)
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

   private var visibleVCModel: (any VCModelProtocol)? {
      visibleViewController as? any VCModelProtocol
   }

   override var preferredStatusBarStyle: UIStatusBarStyle {
      if let vc = visibleVCModel {
         return vc.currentStatusBarStyle ?? currentStatusBarStyle ?? .default
      } else {
         return currentStatusBarStyle ?? .default
      }
   }

   func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
      if let vc = viewController as? any VCModelProtocol {
         if vc.currentBarStyle == nil, let currentBarStyle {
            barStyle(currentBarStyle)
         }
         if vc.currentBarTintColor == nil, let currentBarTintColor {
            navBarTintColor(currentBarTintColor)
         }
         if vc.currentTitleColor == nil, let currentTitleColor {
            titleColor(currentTitleColor)
         }
         if vc.currentTitleAlpha == nil, let currentTitleAlpha {
            titleAlpha(currentTitleAlpha)
         }
         if vc.currentBarTranslucent == nil, let currentBarTranslucent {
            barTranslucent(currentBarTranslucent)
         }
         if vc.currentBarBackColor == nil, let currentBarBackColor {
            barBackColor(currentBarBackColor)
         }
      }
   }
}

extension NavController {
   @discardableResult func barStyle(_ value: UIBarStyle) -> Self {
      currentBarStyle = value
      navigationBar.barStyle = value
      return self
   }

   @discardableResult func navBarTintColor(_ value: UIColor) -> Self {
      currentBarTintColor = value
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
      currentTitleColor = value
      let textAttributes = [NSAttributedString.Key.foregroundColor: value]
      navigationBar.titleTextAttributes = textAttributes
      return self
   }

   @discardableResult func barTranslucent(_ value: Bool) -> Self {
      currentBarTranslucent = value
      navigationBar.isTranslucent = value
      return self
   }

   @discardableResult func barBackColor(_ value: UIColor) -> Self {
      currentBarBackColor = value
      navigationBar.backgroundColor = value
      return self
   }

   @discardableResult func titleAlpha(_ value: CGFloat) -> Self {
      currentTitleAlpha = value
      navigationItem.titleView?.alpha = value
      return self
   }
}
