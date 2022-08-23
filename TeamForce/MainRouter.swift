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
   case presentModally
}

protocol RouterProtocol: InitProtocol {}

final class MainRouter<Scene: InitProtocol>: RouterProtocol, Communicable {
   var events: Events = .init()

   func start() {}

   struct Events: InitProtocol {
      var push: Event<UIViewController>?
      var pop: Event<Void>?
      var popToRoot: Event<Void>?
      var present: Event<UIViewController>?
      var presentModally: Event<UIViewController>?
   }

   func route(_ keypath: KeyPath<Scene, SceneModelProtocol>, navType: NavType, payload: Any? = nil) {
      switch navType {
      case .push:
         sendEvent(\.push, payload: makeVC())
      case .pop:
         sendEvent(\.pop)
      case .popToRoot:
         sendEvent(\.popToRoot)
      case .present:
         sendEvent(\.present, payload: makeVC())
      case .presentModally:
         sendEvent(\.presentModally, payload: makeVC())
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
