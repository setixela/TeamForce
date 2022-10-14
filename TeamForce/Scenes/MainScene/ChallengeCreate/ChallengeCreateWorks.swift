//
//  ChallengeCreateWorks.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 11.10.2022.
//

import ReactiveWorks
import UIKit

protocol ChallengeCreateWorksProtocol {
   var createChallenge: Work<ChallengeRequestBody, Void> { get }
}

final class ChallengeCreateWorksStore: InitProtocol, ImageStorage {
   var images: [UIImage] = []
}

final class ChallengeCreateWorks<Asset: AssetProtocol>: BaseSceneWorks<ChallengeCreateWorksStore, Asset> {
   private lazy var apiUseCase = Asset.apiUseCase
}

extension ChallengeCreateWorks: ChallengeCreateWorksProtocol {
   var createChallenge: Work<ChallengeRequestBody, Void> { .init { [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.CreateChallenge
         .doAsync(input)
         .onSuccess {
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
}

extension ChallengeCreateWorks: ImageWorks {}
