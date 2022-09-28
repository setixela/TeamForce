//
//  FeedDetailViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 26.09.2022.
//

import ReactiveWorks
import UIKit

final class FeedDeatilViewModel<Asset: AssetProtocol>: //ModalDoubleStackModel<Asset>, Eventable
BaseSceneModel<
   DefaultVCModel,
   DoubleStacksBrandedVM<Asset.Design>,
   Asset,
   (Feed, String)
>//, Scenarible, Stateable2
{
   typealias State = ViewState
   typealias State2 = StackState
   
//   lazy var scenario: Scenario = FeedDetailScenario<Asset>(
//      works: FeedWorks<Asset>(),
//      stateDelegate: stateDelegate,
//      events: FeedDetailEvents(
//         loadComments: <#VoidWork<CommentsRequest>#>)
//   )
   
   var userName: String = ""
   lazy var presenter = CommentPresenters<Design>()

   private lazy var topBlock = StackModel()
      .distribution(.fill)
      .alignment(.center)
      .arrangedModels([
         Spacer(32),
         image,
         Spacer(8),
         dateLabel,
         Spacer(8),
         infoLabel,
         Spacer(16),
         reactionsBlock,
         Spacer(16)
      ])

   private lazy var commentTableModel = TableItemsModel<Design>()
      //.backColor(.lightGray)//Design.color.background)
      .backColor(Design.color.background)
      .set(.presenters([
         presenter.commentCellPresenter,
         SpacerPresenter.presenter
      ]))
   
   // MARK: - Services
   private lazy var apiUseCase = Asset.apiUseCase
   
   override func start() {
      guard let transactionId = inputValue?.0.transaction.id else { return }
      let request = CommentsRequest(token: "",
                                    body: CommentsRequestBody(
                                       transactionId: transactionId,
                                       includeName: true
                                    ))
      apiUseCase.getComments
         .doAsync(request)
         .onSuccess {
            //print("I am success \($0)")
            self.commentTableModel.set(.items($0 + [SpacerItem(size: Grid.x64.value)]))
         }
         .onFail {
            print("I am fail to load comments")
         }
      configure()
      configureLabels()
      
//      commentTableModel
//         .on(\.didScroll) { [weak self] in
//            self?.sendEvent(\.didScroll, $0)
//         }
//         .on(\.willEndDragging) { [weak self] in
//            self?.sendEvent(\.willEndDragging, $0)
//         }
      
   }
   
   private lazy var image = WrappedY(ImageViewModel()
      .image(Design.icon.avatarPlaceholder)
      .contentMode(.scaleAspectFill)
      .cornerRadius(70 / 2)
      .size(.square(70))
      .shadow(Design.params.cellShadow)
   )
   
   private lazy var dateLabel = LabelModel()
      .numberOfLines(0)
      .set(Design.state.label.caption)
      .textColor(Design.color.textSecondary)
      
   
   private lazy var infoLabel = LabelModel()
      .numberOfLines(0)
      .set(Design.state.label.caption)
      .textColor(Design.color.iconBrand)
   
   private lazy var likeButton = ReactionButton<Design>()
      .setAll {
         $0.image(Design.icon.like)
         $1.text("0")
      }
   
   private lazy var dislikeButton = ReactionButton<Design>()
      .setAll {
         $0.image(Design.icon.dislike)
         $1.text("0")
      }
   
   private lazy var reactionsBlock = StackModel()
      .axis(.horizontal)
      .alignment(.leading)
      .distribution(.fill)
      .spacing(4)
      .arrangedModels([
         likeButton,
         dislikeButton,
         Grid.xxx.spacer
      ])
   
   private func configure() {
      mainVM.headerStack.arrangedModels([Grid.x64.spacer])
      mainVM.bodyStack
         .set(Design.state.stack.default)
         .alignment(.fill)
         .distribution(.fill)
         .set(.backColor(Design.color.backgroundSecondary))
         .arrangedModels([
            topBlock,
            commentTableModel,
            Grid.xxx.spacer
         ])
   }
   
   private func configureLabels() {
      guard
         let feed = inputValue?.0,
         let userName = inputValue?.1
      else { return }
      print("from detail \(feed)")
      configureImage(feed: feed)
      let dateText = FeedPresenters<Design>.makeInfoDateLabel(feed: feed).view.text
      dateLabel.text(dateText ?? "")
      let type = FeedTransactType.make(feed: feed, currentUserName: userName)
      let infoText = FeedPresenters<Design>.makeInfoLabel(feed: feed, type: type).view.attributedText
     
      infoLabel
         .attributedText(infoText!)
      var likeAmount = "0"
      var dislikeAmount = "0"
      if let reactions = feed.transaction.reactions {
         for reaction in reactions {
            if reaction.code == "like" {
               likeAmount = String(reaction.counter ?? 0)
            } else if reaction.code == "dislike" {
               dislikeAmount = String(reaction.counter ?? 0)
            }
         }
      }
      
      likeButton.models.right.text(likeAmount)
      dislikeButton.models.right.text(dislikeAmount)
   }
   
   private func configureImage(feed: Feed) {
      if let recipientPhoto = feed.transaction.photoUrl {
         image.subModel.url(recipientPhoto)
      } else {
         if let nameFirstLetter = feed.transaction.recipientFirstName?.first,
            let surnameFirstLetter = feed.transaction.recipientSurname?.first
         {
            let text = String(nameFirstLetter) + String(surnameFirstLetter)
            DispatchQueue.global(qos: .background).async {
               let image = text.drawImage(backColor: Design.color.backgroundBrand)
               DispatchQueue.main.async {
                  self.image.subModel
                     .backColor(Design.color.backgroundBrand)
                     .image(image)
               }
            }
         }
      }
   }
}

//enum FeedDetailSceneState {
//   case presentComments([Comment])
//}
//extension FeedDeatilViewModel: StateMachine {
//   func setState(_ state: FeedDetailSceneState) {
//      self.state = state
//      switch state {
//      case .presentComments(let tuple):
//         commentTableModel.set(.items(tuple.0 + [SpacerItem(size: Grid.x64.value)]))
//      }
//   }
//}
