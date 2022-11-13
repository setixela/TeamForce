//
//  ChallengeDetailsScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 10.10.2022.
//

import ReactiveWorks

struct ChallengeDetailsInputEvents {
   let saveInputAndLoadChallenge: VoidWork<ChallengeDetailsSceneInput>

   let challengeResult: VoidWorkVoid
   let filterButtonTapped: VoidWork<Button6Event>
   let acceptPressed: VoidWork<Int>
   let rejectPressed: VoidWork<Int>

   let didSelectWinnerIndex: VoidWork<Int>

   let didEditingComment: VoidWork<String>
   let didSendCommentPressed: VoidWorkVoid

   let reactionPressed: VoidWorkVoid
}

final class ChallengeDetailsScenario<Asset: AssetProtocol>: BaseScenario<ChallengeDetailsInputEvents,
   ChallengeDetailsState,
   ChallengeDetailsWorks<Asset>>
{
   override func start() {
      events.saveInputAndLoadChallenge
         .onSuccess(setState) { .setHeaderImage($0.challenge?.photoCache) }
         .doNext(works.saveInput)
         .onSuccess(setState) { .sendFilterButtonEvent($0.currentButton) }
         .doVoidNext(works.getChallengeById)
         .onSuccess(setState) { .updateDetails($0) }
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
       //  .doSaveResult()
       //  .doVoidNext(works.getProfileId)
         .onSuccess(setState) {
            .presentSendResultScreen($0)
         }

      events.filterButtonTapped
         .onSuccess(setState, .presentActivityIndicator)
         .doNext(works.filterButtonWork)
         .onSuccess { [weak self] (result: ChallengeDetailsWorks.Button6Result) in
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
            }
         }
         .onFail {
            print("fail button works")
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
         .onSuccess(setState) { .presentContenders($0) }
         .onFail { print("fail") }

      events.didSelectWinnerIndex
         .doNext(works.getWinnerReportIdByIndex)
         // .doNext(works.getInputForReportDetail)
         .onSuccess(setState) { .presentReportDetailView($0) }
         .onFail { print("fail") }

      events.didEditingComment
         .doNext(works.updateInputComment)
         .doNext(usecase: IsEmpty())
         .onSuccess(setState, .sendButtonDisabled)
         .onFail(setState, .sendButtonEnabled)

      events.didSendCommentPressed
         .onSuccess(setState, .sendButtonDisabled)
         .doNext(works.createComment)
         .onSuccess(setState, .commentDidSend)
         .onFail { print("error sending comment") }

      events.reactionPressed
         .doNext(works.isLikedByMe)
         .onSuccess(setState) { .buttonLikePressed(alreadySelected: $0) }
         .doVoidNext(works.pressLike)
         .onFail(setState) { .failedToReact(alreadySelected: $0) }
         .doVoidNext(works.getLikesAmount)
         .onSuccess(setState) { .updateLikesAmount($0) }
   }
}
