//
//  Scenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.08.2022.
//

import ReactiveWorks

protocol Scenario {
   associatedtype Scenery: SceneryProtocol

   var scenario: Scenery { get }
}

// Сокращение ДЖЕНЕРИКОВ с в стиле Пятачка: ДЖНРК

protocol SceneryProtocol {
   associatedtype VWMDLS
   associatedtype WRKS: SceneWorks

   var works: WRKS { get }
   var vModels: VWMDLS { get }

   init(viewModels: VWMDLS, works: WRKS)
}

class BaseScenery<VWMDLS, WRKS: SceneWorks>: BaseModel, SceneryProtocol {
   let works: WRKS
   let vModels: VWMDLS

   required init(viewModels: VWMDLS, works: WRKS) {
      self.vModels = viewModels
      self.works = works
   }

   required init() {
      fatalError("init() has not been implemented")
   }
}
