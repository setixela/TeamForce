//
//  ChallWinnersPresenters.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 14.10.2022.
//

import ReactiveWorks
import UIKit

class ChallWinnersPresenters<Design: DesignProtocol>: Designable {
   // var events: EventsStore = .init()
   
   var winnersCellPresenter: Presenter<ChallengeWinner, WrappedX<StackModel>> {
      Presenter { work in
         let winner = work.unsafeInput
         let awardedAt = winner.awardedAt.string
         let nickname = winner.nickname.string
         let name = winner.participantName.string
         let surname = winner.participantSurname.string
         let totalReceived = winner.totalReceived

         let icon = ImageViewModel()
            .contentMode(.scaleAspectFill)
            .image(Design.icon.avatarPlaceholder)
            .size(.square(Grid.x36.value))
            .cornerRadius(Grid.x36.value / 2)
         
         let nicknameLabel = LabelModel()
            .text("@" + nickname)
            .set(Design.state.label.body2)
         
         let awardedLabel = LabelModel()
            .text(awardedAt.dateFullConverted)
            .set(Design.state.label.caption)
         
         let receivedLabel = LabelModel()
            .set(Design.state.label.body2)
            .text(String(totalReceived ?? 0) + " спасибок")
            .textColor(Design.color.success)
            
         
         if let avatar = winner.participantPhoto {
            icon.url(TeamForceEndpoints.urlBase + avatar)
         } else {
            if let nameFirstLetter = name.first,
               let surnameFirstLetter = surname.first
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
         
         let infoBlock = StackModel()
            .spacing(Grid.x10.value)
            .axis(.vertical)
            .alignment(.fill)
            .arrangedModels([
               awardedLabel,
               nicknameLabel
            ])
         
         let cellStack = WrappedX(
            StackModel()
               .padding(.outline(Grid.x8.value))
               .spacing(Grid.x12.value)
               .axis(.horizontal)
               .alignment(.center)
               .arrangedModels([
                  icon,
                  infoBlock,
                  Grid.x32.spacer,
                  receivedLabel
               ])
               .cornerRadius(Design.params.cornerRadiusSmall)
               .backColor(Design.color.background)
         )
         .padding(.verticalOffset(Grid.x6.value))
         .cornerRadius(Design.params.cornerRadiusSmall)
         .shadow(Design.params.cellShadow)

         work.success(result: cellStack)
      }
   }
}
