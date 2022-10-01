//
//  FeedDetailScene.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 29.09.2022.
//

import ReactiveWorks
import UIKit

enum FeedDetailsState {
   case initial((Feed, String))
   case details
   case comments([Comment])
   case reactions
}

final class FeedDetailViewModels<Design: DSP>: StackModel, Designable {
   var events: EventsStore = .init()

   private lazy var presenter = CommentPresenters<Design>()

   lazy var topBlock = FeedDetailUserInfoBlock<Design>()

   lazy var filterButtons = FeedDetailFilterButtons<Design>()

   private lazy var detailsBlock = FeedDetailsBlock<Design>()
   private lazy var commentsBlock = FeedCommentsBlock<Design>()

   override func start() {
      setState(.details)
      filterButtons.buttonComments.setMode(\.selected)
   }

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

extension FeedDetailViewModels: Eventable {
   struct Events: InitProtocol {
      var reactionPressed: PressLikeRequest?
      var saveInput: Feed?
   }
}

extension FeedDetailViewModels: StateMachine {
   func setState(_ state: FeedDetailsState) {
      switch state {
      case .initial(let tuple):
         send(\.saveInput, tuple.0)
         arrangedModels([
            topBlock,
            filterButtons,
            detailsBlock
         ])
         topBlock.setup(tuple)
      case .details:
         arrangedModels([
            topBlock,
            filterButtons,
            detailsBlock
         ])
      case .comments(let comments):
         commentsBlock.setup(comments)
         arrangedModels([
            topBlock,
            filterButtons,
         ])
      case .reactions:
         arrangedModels([
            topBlock,
            filterButtons,
         ])
      }
   }
}
