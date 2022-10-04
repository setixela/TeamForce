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
         let item = work.unsafeInput
         let user = item.user

         let icon = ImageViewModel()
            .contentMode(.scaleAspectFill)
            .image(Design.icon.avatarPlaceholder)
            .size(.square(Grid.x36.value))
            .cornerRadius(Grid.x36.value / 2)
         
         let senderLabel = LabelModel()
            .text((user.name.string) + " " + (user.surname.string))
            .set(Design.state.label.body1)
         
         if let avatar = user.avatar {
            icon.url(TeamForceEndpoints.urlBase + avatar)
         } else {
            if let nameFirstLetter = user.name?.first,
               let surnameFirstLetter = user.surname?.first
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
                  senderLabel
               ])
               .cornerRadius(Design.params.cornerRadiusSmall)
         )
         .padding(.verticalOffset(Grid.x16.value))
         
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
