//
//  DetailInputForFeedWorksProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 03.11.2022.
//

import ReactiveWorks

//typealias DetailInput = Result3<
//   NewFeed,
//   ChallengeDetailsSceneInput,
//   ChallengeDetailsSceneInput
//>

protocol DetailInputForFeedWorksProtocol: WorksProtocol, Assetable
where Asset: AssetProtocol
{
   var apiUseCase: ApiUseCase<Asset> { get }

   var getChallengeById: Work<Int, Challenge> { get }
   var createInputForDetailView: Work<(feed: NewFeed, profileId: Int), ChallengeDetailsSceneInput> { get }
}

extension DetailInputForFeedWorksProtocol {
   var getChallengeById: Work<Int, Challenge> { .init { [weak self] work in
      guard let id = work.input else { return }
      self?.apiUseCase.GetChallengeById
         .doAsync(id)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var createInputForDetailView: Work<(feed: NewFeed, profileId: Int), ChallengeDetailsSceneInput> { .init { [weak self] work in

      let input = work.unsafeInput.feed
      let profileId = work.unsafeInput.profileId

      switch input.objectSelector {
      case "Q":
         guard
            let challengeId = input.challenge?.id
         else { work.fail(); return }

         self?.getChallengeById
            .doAsync(challengeId)
            .onSuccess {
               let res = ChallengeDetailsSceneInput(challenge: $0,
                                                    profileId: profileId,
                                                    currentButton: 0)
               work.success(res)
            }
            .onFail { work.fail() }
      case "R":
         guard
            let reportId = input.winner?.id,
            let challengeId = input.winner?.challengeId
         else { work.fail(); return }

         self?.getChallengeById
            .doAsync(challengeId)
            .onSuccess {
               let res = ChallengeDetailsSceneInput(challenge: $0,
                                                    profileId: profileId,
                                                    currentButton: 3,
                                                    reportId: reportId)
               work.success(res)
            }
            .onFail {
               work.fail()
            }
      default:
         work.fail()
      }
   }.retainBy(retainer) }
}
