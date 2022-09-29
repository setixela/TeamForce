//
//  FeedDetailWorks.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 29.09.2022.
//

import Foundation
import ReactiveWorks


final class FeedDetailWorksTempStorage: InitProtocol {
   var feed: [Feed]?
   lazy var currentUserName = ""
   var segmentId: Int?
   var currentTransactId: Int?
}

final class FeedDetailWorks<Asset: AssetProtocol>: BaseSceneWorks<FeedDetailWorksTempStorage, Asset> {
   private lazy var apiUseCase = Asset.apiUseCase


   var pressLike: Work<PressLikeRequest, Void> { .init { [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.pressLike
         .doAsync(input)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getTransactStat: Work<TransactStatRequest, TransactStatistics> { .init { [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.getTransactStatistics
         .doAsync(input)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
   var getComments: Work<CommentsRequest, [Comment]> { .init { [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.getComments
         .doAsync(input)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
   var createComment: Work<CreateCommentRequest, Void> { .init { [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.createComment
         .doAsync(input)
         .onSuccess {
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
   var updateComment: Work<UpdateCommentRequest, Void> { .init { [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.updateComment
         .doAsync(input)
         .onSuccess {
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
   var deleteComment: Work<RequestWithId, Void> { .init { [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.deleteComment
         .doAsync(input)
         .onSuccess {
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
}
