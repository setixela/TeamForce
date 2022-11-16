//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.11.2022.
//

import ReactiveWorks

enum DetailsPresenterState {
   case presentDetails(Details, navType: NavType = .push)
   case presentNothing

   enum Details {
      case transaction(TransactDetailsSceneInput)
      case challenge(ChallengeDetailsInput)
   }
}

final class DetailsPresenter<Asset: AssetProtocol>: Assetable {}

extension DetailsPresenter: StateMachine {
   func setState(_ state: DetailsPresenterState) {
      switch state {
      case .presentDetails(let details, let navType):
         switch details {
         case .transaction(let input):
            Asset.router?.route(
               navType,
               scene: \.transactDetails,
               payload: input
            )
         case .challenge(let challInput):
            Asset.router?.route(
               navType,
               scene: \.challengeDetails,
               payload: challInput
            )
         }
      //
      case .presentNothing:
         assertionFailure("cannot present details")
      }
   }
}
