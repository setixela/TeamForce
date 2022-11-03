//
//  ReactionsPresenters.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 04.10.2022.
//

import ReactiveWorks
import UIKit

class ReactionsPresenters<Design: DesignProtocol>: Designable {
   var events: EventsStore = .init()
   
   var reactionsCellPresenter: Presenter<ReactItem, WrappedX<StackModel>> {
      Presenter { work in
         let item = work.unsafeInput.item
         let user = item.user

         let icon = ImageViewModel()
            .contentMode(.scaleAspectFill)
            .image(Design.icon.newAvatar)
            .size(.square(Grid.x36.value))
            .cornerRadius(Grid.x36.value / 2)
         
         let senderLabel = LabelModel()
            .text((user.name.string) + " " + (user.surname.string))
            .set(Design.state.label.body1)
         
         if let avatar = user.avatar {
            icon.url(TeamForceEndpoints.urlBase + avatar)
         } else {
            let userIconText =
            String(user.name?.first ?? "?") +
            String(user.surname?.first ?? "?")
            DispatchQueue.global(qos: .background).async {
               let image = userIconText.drawImage(backColor: Design.color.backgroundBrand)
               DispatchQueue.main.async {
                  icon
                     .backColor(Design.color.backgroundBrand)
                     .image(image)
               }
            }
         }
         
         let cellStack = WrappedX(
            StackModel()
               .padding(Design.params.cellContentPadding)
               .spacing(Grid.x12.value)
               .axis(.horizontal)
               .alignment(.center)
               .arrangedModels([
                  icon,
                  senderLabel
               ])
               .cornerRadius(Design.params.cornerRadiusSmall)
               .backColor(Design.color.backgroundInfoSecondary)
         )
         .padding(.outline(Grid.x2.value))
         
         work.success(result: cellStack)
      }
   }
}

extension ReactionsPresenters: Eventable {
   struct Events: InitProtocol {
      var didSelect: Int?
      var reactionPressed: PressLikeRequest?
   }
}
