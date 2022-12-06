//
//  ChallengeDetailsScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 10.10.2022.
//

import ReactiveWorks

struct ChallengeDetailsInputEvents {
   let saveInputAndLoadChallenge: WorkVoid<ChallengeDetailsInput>

   let challengeResult: WorkVoidVoid
   let filterButtonTapped: WorkVoid<Button7Event>
   let acceptPressed: WorkVoid<Int>
   let rejectPressed: WorkVoid<Int>

   let didSelectWinnerIndex: WorkVoid<Int>

   let didEditingComment: WorkVoid<String>
   let didSendCommentPressed: WorkVoidVoid

   let reactionPressed: WorkVoidVoid

   let presentChallengeAuthor: WorkVoidVoid
   
   let reportReactionPressed: WorkVoid<PressLikeRequest>
   
   let winnerReportReactionRressed: WorkVoid<PressLikeRequest>
}

final class ChallengeDetailsScenario<Asset: AssetProtocol>: BaseScenario<ChallengeDetailsInputEvents,
   ChallengeDetailsState,
   ChallengeDetailsWorks<Asset>>
{
   override func start() {
      events.saveInputAndLoadChallenge
         .onSuccess(setState) { (input: ChallengeDetailsInput) in
            switch input {
            case .byChallenge(let chall, _):
               return .setHeaderImage(chall.photoCache)
            default:
               return .initial
            }
         }
         .doMap { $0 }
         .onSuccess(setState) {
            switch $0 {
            case .byChallenge(_, let chapter):
               return .presentChapter(chapter)
            case .byFeed(_, let chapter):
               return .presentChapter(chapter)
            case .byId(_, let chapter):
               return .presentChapter(chapter)
            }
         }
         .doNext(works.saveInput)
         .doNext(works.getChallengeById)
         .onSuccess(setState) { .presentChallenge($0) }
         .onFail {
            assertionFailure("fail")
         }
         .doVoidNext(works.amIOwnerCheck)
         .onSuccess(setState, .enableContenders)
         .onFail {
            print("fail")
         }
         .doRecover()
         .doVoidNext(works.getChallengeResult)
         .onSuccess { [weak self] in
            self?.setState(.enableMyResult($0))

            self?.works.anyReportToPresent
               .doAsync()
               .onSuccess {
                  self?.setState(.presentReportDetailView($0))
               }
               .onFail {
                  print("fail")
               }
         }
         .onFail { [weak self] in
            self?.works.anyReportToPresent
               .doAsync()
               .onSuccess {
                  self?.setState(.presentReportDetailView($0))
               }
               .onFail {
                  print("fail")
               }
         }

      events.challengeResult
         .doNext(works.getChallenge)
         .onSuccess(setState) {
            .presentSendResultScreen($0)
         }

      events.filterButtonTapped
         .onSuccess(setState, .presentActivityIndicator)
         .doNext(works.filterButtonWork)
         .onSuccess { [weak self] (result: ChallengeDetailsWorks.Button7Result) in
            // можно сет стейт достать из селфа:
            guard let stateFunc = self?.setState else { return }

            switch result {
            case .result1(let value):
               stateFunc(.presentChallenge(value))

            case .result2(let value):
               guard !value.isEmpty else { stateFunc(.hereIsEmpty); return }

               stateFunc(.presentMyResults(value))

            case .result3(let value):
               guard !value.isEmpty else { stateFunc(.hereIsEmpty); return }

               stateFunc(.presentContenders(value))

            case .result4(let value):
               guard !value.isEmpty else { stateFunc(.hereIsEmpty); return }

               stateFunc(.presentWinners(value))

            case .result5(let value):
               // guard !value.isEmpty else { stateFunc(.hereIsEmpty); return }

               stateFunc(.presentComments(value))

            case .result6:
               break

            case .result7(let value):
               guard !value.isEmpty else { stateFunc(.hereIsEmpty); return }

               stateFunc(.presentReactions(value))
            }
         }
         .onFail {
            assertionFailure("fail button works")
         }

      events.rejectPressed
         .doNext(works.getInputForCancel)
         .onSuccess(setState) {
            .presentCancelView($0.0, $0.1)
         }

      events.acceptPressed
         .doMap { (CheckReportRequestBody.State.W, $0) }
         .doNext(works.checkChallengeReport)
         .doNext(works.getChallengeContenders)
         .onSuccess { [weak self] contenders in
            guard !contenders.isEmpty else { self?.setState(.hereIsEmpty); return }

            self?.setState(.presentContenders(contenders))
         }
         .onFail { assertionFailure("fail") }

      events.didSelectWinnerIndex
         .doNext(works.getWinnerReportIdByIndex)
         .onSuccess(setState) { .presentReportDetailView($0) }
         .onFail { assertionFailure("fail") }

      events.didEditingComment
         .doNext(works.updateInputComment)
         .doNext(usecase: IsEmpty())
         .onSuccess(setState, .sendButtonDisabled)
         .onFail(setState, .sendButtonEnabled)

      events.didSendCommentPressed
         .onSuccess(setState, .sendButtonDisabled)
         .doNext(works.createComment)
         .onSuccess(setState, .commentDidSend)
         .onFail { assertionFailure("error sending comment") }

      events.reactionPressed
         .doNext(works.isLikedByMe)
         .onSuccess(setState) { .buttonLikePressed(alreadySelected: $0) }
         .doVoidNext(works.pressLike)
         .onFail(setState) { .failedToReact(alreadySelected: $0) }
         .doVoidNext(works.getLikesAmount)
         .onSuccess(setState) { .updateLikesAmount($0) }

      events.presentChallengeAuthor
         .doNext(works.getCreatorId)
         .onSuccess(setState) { .presentCreator($0) }
      
      events.reportReactionPressed
         .doNext(works.pressLikeContender)
         .onSuccess {
            print("hello")
         }
         .doMap { [weak self] stat in
            let index = self?.events.reportReactionPressed.result?.index ?? 0
            let res = (stat, index)
            return res
         }
         .doNext(works.updateContenderReportItem)
         .onSuccess(setState) {
            .updateContenderAtIndex($0.0, $0.1)
         }
         .onFail {
            print("fail")
         }
      
      events.winnerReportReactionRressed
         .doNext(works.pressLikeContender)
         .onSuccess {
            print("hello")
         }
         .onFail {
            print("hello")
         }
         .doMap { [weak self] stat in
            let index = self?.events.winnerReportReactionRressed.result?.index ?? 0
            let res = (stat, index)
            return res
         }
         .doNext(works.updateWinnerReportItem)
         .onSuccess(setState) {
            .updateWinnerAtIndex($0.0, $0.1)
         }
         .onFail {
            print("fail")
         }
//         .doNext(works.updateFeedElement)
//         .onSuccess(setState) {
//            .updateFeedAtIndex($0.0, $0.1)
//         }
   }
}
