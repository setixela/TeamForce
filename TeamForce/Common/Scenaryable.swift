//
//  Scenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.08.2022.
//

import ReactiveWorks

protocol Scenaryable {
   associatedtype Scenery: Scenario

   var scenario: Scenery { get }
}

protocol Scenario {
   associatedtype Works: SceneWorks
   associatedtype Events
   associatedtype State

   init(works: Works, events: Events)

   var events: Events { get }

   func start(setState: @escaping (State) -> Void)
}

class BaseScenario<Events, State, Works: SceneWorks>: BaseModel, Scenario {
   var works: Works
   var events: Events

   required init(works: Works, events: Events) {
      self.events = events
      self.works = works
   }

   required init() {
      fatalError("init() has not been implemented")
   }

   open func start(setState: @escaping (State) -> Void) {   }
}

