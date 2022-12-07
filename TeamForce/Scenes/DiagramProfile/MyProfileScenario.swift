//
//  DiagramProfileScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 05.12.2022.
//

import ReactiveWorks
import CoreLocation

struct MyProfileScenarioInput {
   let locationCoordinates: WorkVoid<CLLocation>
}

struct DiagramProfileScenarioParams<Asset: ASP>: ScenarioParams {
   typealias ScenarioInputEvents = MyProfileScenarioInput
   typealias ScenarioModelState = MyProfileSceneState
   typealias ScenarioWorks = MyProfileWorks<Asset>
}

final class MyProfileScenario<Asset: ASP>: BaseAssettableScenario<DiagramProfileScenarioParams<Asset>> {
   override func start() {
      works.loadMyProfile
         .doAsync()
         .doVoidNext(works.getUserStatus)
         .onSuccess(setState) { .userStatus($0) }
         .doVoidNext(works.getDiagramData)
         .onSuccess(setState) { .diagramData($0) }
         .doVoidNext(works.getUserContacts)
         .onSuccess(setState) { .userContacts($0) }
         .doVoidNext(works.getUserWorkData)
         .onSuccess(setState) { .userWorkPlace($0) }
         .doVoidNext(works.getUserRoleData)
         .onSuccess(setState) { .userRole($0) }

      events.locationCoordinates
         .doNext(works.getUserLocationData)
         .onSuccess(setState) { .userLocation($0) }
   }
}
