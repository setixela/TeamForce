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
   case reactions([Item])
   case loadingActivity

   case sendButtonDisabled
   case sendButtonEnabled
   case commentDidSend
}

final class FeedDetailViewModels<Design: DSP>: DoubleStacksModel, Designable {
   var events: EventsStore = .init()

   lazy var topBlock = FeedDetailUserInfoBlock<Design>()

   lazy var filterButtons = FeedDetailFilterButtons<Design>()

   private lazy var detailsBlock = FeedDetailsBlock<Design>()
   lazy var commentsBlock = FeedCommentsBlock<Design>()
   lazy var reactionsBlock = FeedReactionsBlock<Design>()

   override func start() {
      super.start()

      bodyStack.arrangedModels([
         topBlock,
         filterButtons
      ])

      filterButtons.buttonDetails.setMode(\.selected)
   }
}

extension FeedDetailViewModels: Eventable {
   struct Events: InitProtocol {
      // var reactionPressed: PressLikeRequest?
      var saveInput: Feed?
   }
}

extension FeedDetailViewModels: StateMachine {
   func setState(_ state: FeedDetailsState) {
      switch state {
      case .initial(let tuple):
         send(\.saveInput, tuple.0)
         topBlock.setup(tuple)
         setState(.details(tuple.0))
      case .details(let feed):
         detailsBlock.setup(feed)
         footerStack.arrangedModels([
            detailsBlock,
            Spacer()
         ])
      case .comments(let comments):
         commentsBlock.setup(comments)
         footerStack.arrangedModels([
            commentsBlock
         ])
      case .reactions(let items):
         reactionsBlock.setup(items)
         footerStack.arrangedModels([
            reactionsBlock
         ])
      case .loadingActivity:
         footerStack.arrangedModels([
            ActivityIndicator<Design>(),
            Spacer()
         ])
      case .sendButtonDisabled:
         commentsBlock.setState(.sendButtonDisabled)
      case .sendButtonEnabled:
         commentsBlock.setState(.sendButtonEnabled)
      case .commentDidSend:
         commentsBlock.commentField.text("")
         commentsBlock.setState(.sendButtonDisabled)
      }
   }
}
