//
//  FeedDetailScene.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 29.09.2022.
//

import ReactiveWorks
import UIKit

enum FeedDetailsState {
   case details
   case comments
   case reactions
}

final class FeedDetailViewModels<Design: DSP>: StackModel, Designable {
   var events: EventsStore = .init()

   private lazy var presenter = CommentPresenters<Design>()
   lazy var topBlock = FeedDetailUserInfoBlock<Design>()

   override func start() {
      setState(.details)
      topBlock.filterButtons.buttonComments.setMode(\.selected)
   }

//   func configureLabels(input: (Feed, String)) {

//      if let reason = feed.transaction.reason {
//         topBlock.reasonLabel.models.down.text(reason)
//         topBlock.reasonLabel.hidden(false)
//         topBlock.infoStack.hidden(false)
//      }

//      if let photoLink = feed.transaction.photoUrl {
//         transactPhoto.models.down.url(TeamForceEndpoints.urlBase + photoLink)
//         transactPhoto.hidden(false)
//         infoStack.hidden(false)
//      }
//   }

   func configureEvents(feed: Feed) {
      let transactionId = feed.transaction.id
      send(\.saveInput, feed)

      topBlock.likeButton.view.startTapGestureRecognize()
      topBlock.dislikeButton.view.startTapGestureRecognize()

      topBlock.likeButton.view.on(\.didTap, self) {
         let request = PressLikeRequest(token: "",
                                        likeKind: 1,
                                        transactionId: transactionId)
         $0.send(\.reactionPressed, request)
      }

      topBlock.dislikeButton.view.on(\.didTap, self) {
         let request = PressLikeRequest(token: "",
                                        likeKind: 2,
                                        transactionId: transactionId)
         $0.send(\.reactionPressed, request)
      }

//      commentField
//         .on(\.didBeginEditing, self) { slf, _ in
//            slf.infoStack.hidden(true)
//            slf.topBlock.hidden(true)
//         }
//         .on(\.didEndEditing, self) { slf, _ in
//            slf.infoStack.hidden(false)
//            slf.topBlock.hidden(false)
//         }
   }
}

extension FeedDetailViewModels: Eventable {
   struct Events: InitProtocol {
      var reactionPressed: PressLikeRequest?
      var saveInput: Feed?
   }
}

extension FeedDetailViewModels: StateMachine {
   func setState(_ state: FeedDetailsState) {
      switch state {
      case .details:
         arrangedModels([
            topBlock
         ])
      case .comments:
         arrangedModels([
            topBlock
         ])
      case .reactions:
         arrangedModels([
            topBlock
         ])
      }
   }
}
