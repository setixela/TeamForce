//
//  Scenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.08.2022.
//

import ReactiveWorks

protocol Scenarible {
   associatedtype Scenery: Scenario

   var scenario: Scenery { get }
}

protocol Scenarible2: Scenarible {
   associatedtype Scenery2: Scenario

   var scenario2: Scenery2 { get }
}

protocol Scenarible3: Scenarible2 {
   associatedtype Scenery3: Scenario

   var scenario3: Scenery3 { get }
}

// MARK: - Scenario protocol and base scenario

protocol Scenario {
   associatedtype Works: TempStorage
   associatedtype Events
   associatedtype State

   init(works: Works, stateDelegate: ((State) -> Void)?, events: Events)

   var events: Events { get }
   var setState: (State) -> Void { get set }

   func start()
}

class BaseScenario<Events, State, Works: TempStorage>: Scenario {
   var works: Works
   var events: Events
   var setState: (State) -> Void = { _ in
      log("stateDelegate (setState:) did not injected into Scenario")
   }

   required init(works: Works, stateDelegate: ((State) -> Void)? = nil, events: Events) {
      self.events = events
      self.works = works
      if let setStateFunc = stateDelegate {
         setState = setStateFunc
      }
   }

   required init() {
      fatalError("init() has not been implemented")
   }

   open func start() {}
}
