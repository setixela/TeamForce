//
//  CommentPresenters.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 28.09.2022.
//

import ReactiveWorks
import UIKit

class CommentPresenters<Design: DesignProtocol>: Designable {
   var events: EventsStore = .init()
   private lazy var retainer = Retainer()
   
   var commentCellPresenter: Presenter<Comment, WrappedX<StackModel>> {
      Presenter { [weak self] work in
         guard let self else { assert(false); return }
         
         let comment = work.unsafeInput
         
         let text = comment.text
         let picture = comment.picture
         let created = comment.created?.timeAgoConverted
         let edited = comment.edited
         let user = comment.user
         
         let senderLabel = LabelModel()
            .text((user?.name.string ?? "") + " " + (user?.surname.string ?? ""))
            .set(Design.state.label.body1)
         
         let textLabel = LabelModel()
            .set(Design.state.label.caption)
            .text(text.string)
            .numberOfLines(0)
         
         let dateLabel = LabelModel()
            .text(created.string)
            .set(Design.state.label.caption)
            .numberOfLines(0)
            .textColor(Design.color.textSecondary)
         
         var likeAmount = "0"
         var dislikeAmount = "0"
        
         let likeButton = ReactionButton<Design>()
            .setAll {
               $0.image(Design.icon.like)
               $1.text(likeAmount)
            }
         
         let dislikeButton = ReactionButton<Design>()
            .setAll {
               $0.image(Design.icon.dislike)
               $1.text(dislikeAmount)
            }
         
         let reactionsBlock = StackModel()
            .axis(.horizontal)
            .alignment(.leading)
            .distribution(.fill)
            .spacing(4)
            .arrangedModels([
               likeButton,
               dislikeButton,
               Grid.xxx.spacer
            ])
         
         let infoBlock = StackModel()
            .spacing(Grid.x10.value)
            .axis(.vertical)
            .alignment(.fill)
            .arrangedModels([
               senderLabel,
               textLabel,
               dateLabel,
               reactionsBlock
            ])
         
         let icon = ImageViewModel()
            .contentMode(.scaleAspectFill)
            .image(Design.icon.avatarPlaceholder)
            .size(.square(Grid.x36.value))
            .cornerRadius(Grid.x36.value / 2)
         
         if let avatar = user?.avatar {
            icon.url(TeamForceEndpoints.urlBase + avatar)
         } else {
            if let nameFirstLetter = user?.name?.first,
               let surnameFirstLetter = user?.surname?.first
            {
               let text = String(nameFirstLetter) + String(surnameFirstLetter)
               DispatchQueue.global(qos: .background).async {
                  let image = text.drawImage(backColor: Design.color.backgroundBrand)
                  DispatchQueue.main.async {
                     icon
                        .backColor(Design.color.backgroundBrand)
                        .image(image)
                  }
               }
            }
         }
         
         let cellStack = WrappedX(
            StackModel()
               .padding(.outline(Grid.x8.value))
               .spacing(Grid.x12.value)
               .axis(.horizontal)
               .alignment(.top)
               .arrangedModels([
                  icon,
                  infoBlock
               ])
               .cornerRadius(Design.params.cornerRadiusSmall)
         )
            .padding(.verticalOffset(Grid.x16.value))
         
         self.retainer.retain(work)
         work.success(result: cellStack)
      }
   }
}


extension CommentPresenters: Eventable {
   struct Events: InitProtocol {
      var didSelect: Int?
      var reactionPressed: PressLikeRequest?
   }
}
