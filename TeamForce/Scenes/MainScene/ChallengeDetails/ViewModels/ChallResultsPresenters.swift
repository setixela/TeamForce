//
//  ChallResultsPresenters.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 14.10.2022.
//

import ReactiveWorks
import UIKit

class ChallResultsPresenters<Design: DesignProtocol>: Designable {
   // var events: EventsStore = .init()
   
   var resultsCellPresenter: Presenter<ChallengeResult, WrappedX<StackModel>> {
      Presenter { work in
         let result = work.unsafeInput
         let updatedAt = result.updatedAt
         let text = result.text.string
         let status = result.status
         
         let textLabel = LabelModel()
            .text(text)
            .numberOfLines(0)
            .set(Design.state.label.caption)
         
         let statusLabel = LabelModel()
            .text(status)
            .numberOfLines(0)
            .set(Design.state.label.caption)
            .backColor(Design.color.backgroundInfoSecondary)
         
         let updateAtLabel = LabelModel()
            .text(updatedAt.dateFullConverted)
            .set(Design.state.label.caption)
         
         let photo = ImageViewModel()
            .image(Design.icon.transactSuccess)
            .height(130)
            .width(130)
            .contentMode(.scaleAspectFill)
            .cornerRadius(Design.params.cornerRadiusSmall)
            .hidden(true)
         
         if let photoLink = result.photo {
            photo.url(TeamForceEndpoints.urlBase + photoLink)
            photo.hidden(false)
         }
         
         let upperStack = StackModel()
            .axis(.horizontal)
            .alignment(.leading)
            .distribution(.fill)
            .spacing(20)
            .arrangedModels([
               statusLabel,
               updateAtLabel
            ])
         
         let awardLabel = LabelModel()
            .text("Ваша награда:")
            .numberOfLines(1)
            .set(Design.state.label.body1)
         
         let recievedStack = StackModel()
            .padding(Design.params.cellContentPadding)
            .spacing(Grid.x12.value)
            .alignment(.leading)
            .arrangedModels([
               awardLabel
            ])
            .cornerRadius(Design.params.cornerRadiusSmall)
            .backColor(Design.color.background)
            .shadow(Design.params.cellShadow)
            .hidden(true)
         
         if status == "Получено вознаграждение" {
            if let received = result.received {
               awardLabel.text("Ваша награда: \(received)")
               recievedStack.hidden(false)
            }
         }
         
         let cellStack = StackModel()
            .padding(Design.params.cellContentPadding)
            .spacing(Grid.x12.value)
            .alignment(.leading)
            .arrangedModels([
               upperStack,
               textLabel,
               photo
            ])
            .cornerRadius(Design.params.cornerRadiusSmall)
            .backColor(Design.color.background)
            .shadow(Design.params.cellShadow)
         
         let finalCell = WrappedX(
            StackModel()
               //.padding(Design.params.cellContentPadding)
               .spacing(Grid.x12.value)
               .alignment(.fill)
               .arrangedModels([
                  cellStack,
                  recievedStack
               ])
               .cornerRadius(Design.params.cornerRadiusSmall)
               .backColor(Design.color.background)
         )
         .padding(.verticalOffset(Grid.x6.value))
         //.padding(.outline(Grid.x2.value))

         work.success(result: finalCell)
      }
   }
}
