//
//  ChallengeCellPresenters.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.11.2022.
//

import Foundation

struct ChallengeCellPresenters<Design: DSP>: Designable {
   static var presenter: Presenter<Challenge, ChallengeCell<Design>> { .init { work in
      let data = work.unsafeInput.item

      let model = ChallengeCell<Design>()
         .setAll { infoBlock, statusBlock in
            infoBlock.setAll { title, winner, prizeFund, prizes in

               title.title.text(data.name.string)

               let creatorName = data.creatorName.string
               let creatorSurname = data.creatorSurname.string
               title.body.text("от " + creatorName + " " + creatorSurname)
               //               participant.title.text(data.approvedReportsAmount.toString)
               //               participant.body.text("Участников")

               winner.title.text(data.awardees.toString)
               winner.body.text("Победителей")

               prizeFund.title.text(data.fund.toString)
               prizeFund.body.text("Призовой фонд")

               prizes.title.text(data.awardees.toString)
               prizes.body.text("Призовых мест")
            }

            let updatedDateString = data.updatedAt.string.convertToDate(.digits)
            statusBlock.statusLabel.text(data.active.bool ? "Активен" : "Завершен")
            statusBlock.dateLabel.text("Обновлен: " + updatedDateString.string)
            statusBlock.backImage
               .image(Design.icon.challengeWinnerIllustrate)
               .contentMode(.scaleAspectFit)
         }

      if let suffix = data.photo {
         model.setState(.inverted)
         model.back
            .backColor(Design.color.iconContrast)
            .addModel(
               ViewModel()
                  .backColor(Design.color.iconContrast)
                  .alpha(0.6)
            ) { anchors, view in
               anchors.fitToView(view)
            }
            .url(TeamForceEndpoints.urlBase + suffix) {
               data.photoCache = $1
            }
      }

      work.success(model)
   } }
}
