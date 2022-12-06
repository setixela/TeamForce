//
//  DiagramProfileScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 05.12.2022.
//

import ReactiveWorks

struct MyProfileScenarioInput {
//   let loadMyProfile: WorkVoidVoid
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
   }
}
