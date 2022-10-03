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
   case details(Feed)
   case comments([Comment])
   case reactions
   case loadingActivity
}

final class FeedDetailViewModels<Design: DSP>: StackModel, Designable {
   var events: EventsStore = .init()

   private lazy var presenter = CommentPresenters<Design>()

   lazy var topBlock = FeedDetailUserInfoBlock<Design>()

   lazy var filterButtons = FeedDetailFilterButtons<Design>()

   private lazy var detailsBlock = FeedDetailsBlock<Design>()
   private lazy var commentsBlock = FeedCommentsBlock<Design>()

   override func start() {
      filterButtons.buttonDetails.setMode(\.selected)
   }

}

extension FeedDetailViewModels: Eventable {
   struct Events: InitProtocol {
      //var reactionPressed: PressLikeRequest?
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
            detailsBlock,
            Spacer()
         ])
         topBlock.setup(tuple)
      case .details(let feed):
         detailsBlock.setup(feed)
         arrangedModels([
            topBlock,
            filterButtons,
            detailsBlock,
            Spacer()
         ])
      case .comments(let comments):
         commentsBlock.setup(comments)
         arrangedModels([
            topBlock,
            filterButtons,
            commentsBlock,
         ])
      case .reactions:
         arrangedModels([
            topBlock,
            filterButtons,
         ])
      case .loadingActivity:
         arrangedModels([
            topBlock,
            filterButtons,
            ActivityIndicator<Design>()
         ])
      }
   }
}
