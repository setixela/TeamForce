//
//  ChallengeDetailsWorks+Misc.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.11.2022.
//

import ReactiveWorks

extension ChallengeDetailsWorks {
   var anyReportToPresent: Work<Void, Int> { .init { work in
      guard
         let reportId = Self.store.reportId
      else {
         work.fail()
         return
      }
      Self.store.reportId = nil
      work.success(reportId)

   }.retainBy(retainer) }

   var getInputForCancel: Work<Int, (Challenge, Int)> { .init { work in
      guard
         let resultId = work.input,
         let challenge = Self.store.challenge

      else { return }

      work.success((challenge, resultId))
   }.retainBy(retainer) }

   //   var getInputForReportDetail: Work<Void, Int> { .init { work in
   //      guard
   //         let reportId = Self.store.reportId
   //      else { return }
   //
   //      work.success(reportId)
   //   }.retainBy(retainer) }

   var getWinnerReportIdByIndex: Work<Int, Int> { .init { work in
      let id = Self.store.winnersReports[work.unsafeInput].id
      work.success(id)
   }.retainBy(retainer) }
}

extension ChallengeDetailsWorks: ChallengeDetailsWorksProtocol {
   var getChallengeWinners: Work<Void, [ChallengeWinner]> { .init { [weak self] work in
      guard let id = Self.store.challengeId else { return }
      self?.apiUseCase.getChallengeWinners
         .doAsync(id)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var checkChallengeReport: Work<(CheckReportRequestBody.State, Int), Void> { .init { [weak self] work in
      guard
         let state = work.input?.0,
         let id = work.input?.1
      else { return }

      let request = CheckReportRequestBody(id: id, state: state, text: "")
      self?.apiUseCase.checkChallengeReport
         .doAsync(request)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var updateInputComment: Work<String, String> { .init { work in
      Self.store.inputComment = work.unsafeInput
      work.success(result: work.unsafeInput)
   }.retainBy(retainer) }

   var createComment: Work<Void, Void> { .init { [weak self] work in
      guard
         let id = Self.store.challengeId
      else { return }

      let body = CreateCommentBody(challengeId: id, text: Self.store.inputComment)
      let request = CreateCommentRequest(token: "", body: body)

      self?.apiUseCase.createComment
         .doAsync(request)
         .onSuccess {
            work.success()
            Self.store.inputComment = ""
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getLikesAmount: Work<Void, Int> { .init { [weak self] work in
      guard let id = Self.store.challengeId else { work.fail(); return }
      let body = LikesCommentsStatRequest.Body(challengeId: id)
      let request = LikesCommentsStatRequest(token: "", body: body)
      self?.apiUseCase.getLikesCommentsStat
         .doAsync(request)
         .onSuccess {
            var amount = 0
            if let reactions = $0.likes {
               for reaction in reactions {
                  if reaction.likeKind?.code == "like" {
                     amount = reaction.counter ?? 0
                  }
               }
            }
            work.success(result: amount)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var pressLike: Work<Void, Bool> { .init { [weak self] work in
      guard
         let id = Self.store.challengeId
      else { work.fail(); return }

      let body = PressLikeRequest.Body(likeKind: 1, challengeId: id)
      let request = PressLikeRequest(token: "", body: body, index: 1)
      self?.apiUseCase.pressLike
         .doAsync(request)
         .onSuccess {
            Self.store.userLiked = !Self.store.userLiked
            work.success(Self.store.userLiked)
         }
         .onFail {
            work.fail(Self.store.userLiked)
         }
   }.retainBy(retainer) }

   var isLikedByMe: WorkVoid<Bool> { .init { work in
      let isMyLike = Self.store.userLiked
      work.success(isMyLike)
   }.retainBy(retainer) }
}
