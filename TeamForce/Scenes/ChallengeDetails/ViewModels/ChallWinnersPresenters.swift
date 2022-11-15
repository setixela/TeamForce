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
   
   var winnersCellPresenter: Presenter<ChallengeWinnerReport, WrappedX<StackModel>> {
      Presenter { work in
         let winnerReport = work.unsafeInput.item
         let awardedAt = winnerReport.awardedAt
         let nickname = winnerReport.nickname.string
         let name = winnerReport.participantName.string
         let surname = winnerReport.participantSurname.string
         let award = winnerReport.award

         let icon = ImageViewModel()
            .contentMode(.scaleAspectFill)
            .image(Design.icon.newAvatar)
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
            .text(String(award ?? 0) + " спасибок")
            .textColor(Design.color.success)
            
         
         if let avatar = winnerReport.participantPhoto {
            icon.url(TeamForceEndpoints.urlBase + avatar)
         } else {
            let userIconText =
            String(name.first ?? "?") +
            String(surname.first ?? "?")
            DispatchQueue.global(qos: .background).async {
               let image = userIconText.drawImage(backColor: Design.color.backgroundBrand)
               DispatchQueue.main.async {
                  icon
                     .backColor(Design.color.backgroundBrand)
                     .image(image)
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
                  receivedLabel.righted()
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
