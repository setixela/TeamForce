//
//  FeedDetailScene.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 29.09.2022.
//

import ReactiveWorks
import UIKit

enum FeedDetailsState {
   case initial(feed: Feed, curUsername: String)
   case details(EventTransaction)
   case comments([Comment])
   case reactions([ReactItem])
   case loadingActivity

   case sendButtonDisabled
   case sendButtonEnabled
   case commentDidSend
   case hereIsEmpty
}

final class FeedDetailViewModels<Asset: AssetProtocol>: DoubleStacksModel, Assetable {
   var events: EventsStore = .init()

   lazy var infoBlock = FeedDetailUserInfoBlock<Design>()

   lazy var filterButtons = FeedDetailFilterButtons<Design>()

   lazy var commentsBlock = FeedCommentsBlock<Design>()
   lazy var reactionsBlock = FeedReactionsBlock<Design>()

   private lazy var detailsBlock = FeedDetailsBlock<Asset>()

   override func start() {
      super.start()

      bodyStack.arrangedModels([
         infoBlock,
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
      case .initial(let feedElement, let curUserName):
         send(\.saveInput, feedElement)
         if let transaction = feedElement.transaction {
            infoBlock.setup((transaction, curUserName))
            setState(.details(transaction))
         }
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
      case .hereIsEmpty:
         footerStack.arrangedModels([
            HereIsEmptySpacedBlock<Design>()
         ])
      }
   }
}
