//
//  ChallContendersPresenters.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 14.10.2022.
//

import ReactiveWorks
import UIKit

class ChallContendersPresenters<Design: DesignProtocol>: Designable {
   var events: EventsStore = .init()

   var contendersCellPresenter: Presenter<Contender, WrappedX<StackModel>> {
      Presenter { work in
         let contender = work.unsafeInput.item
         let createdAt = contender.reportCreatedAt
         let name = contender.participantName.string
         let surname = contender.participantSurname.string
         let reportText = contender.reportText.string
         let reportId = contender.reportId

         let senderLabel = LabelModel()
            .text(name + " " + surname)
            .set(Design.state.label.body1)

         let createdAtLabel = LabelModel()
            .text(createdAt.dateFullConverted)
            .set(Design.state.label.caption)
            .textColor(Design.color.textSecondary)

         let icon = ImageViewModel()
            .contentMode(.scaleAspectFill)
            .image(Design.icon.avatarPlaceholder)
            .size(.square(Grid.x36.value))
            .cornerRadius(Grid.x36.value / 2)

         let infoBlock = StackModel()
            .spacing(Grid.x6.value)
            .axis(.vertical)
            .alignment(.fill)
            .arrangedModels([
               senderLabel,
               createdAtLabel
            ])

         if let avatar = contender.participantPhoto {
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

         let userInfo = StackModel()
            .padding(.outline(Grid.x8.value))
            .spacing(Grid.x12.value)
            .axis(.horizontal)
            .alignment(.center)
            .arrangedModels([
               icon,
               infoBlock
            ])
            .cornerRadius(Design.params.cornerRadiusSmall)
            .backColor(Design.color.background)

         let textLabel = LabelModel()
            .set(Design.state.label.caption)
            .text(reportText)
            .padding(Design.params.cellContentPadding)

         let photo = ImageViewModel()
            .image(Design.icon.transactSuccess)
            .height(130)
            .width(130)
            .contentMode(.scaleAspectFill)
            .cornerRadius(Design.params.cornerRadiusSmall)
            .hidden(true)

         if let photoLink = contender.reportPhoto, photoLink.count > 1 {
            photo.url(TeamForceEndpoints.urlBase + photoLink)
            photo.hidden(false)
         }

         let rejectButton = ButtonModel()
            .set(Design.state.button.default)
            .backColor(Design.color.backgroundBrand)
            .title("Отклонить")
            .font(Design.font.default)
            .padding(.sideOffset(Grid.x14.value))
            .height(Design.params.buttonHeightSmall)
            .cornerRadius(Design.params.cornerRadiusSmall)

//         let rejectButton1 = ReactionButton<Design>()
//            .setAll {
//               $0.hidden(true)
//               $1.text("Отклонить")
//            }
//            .height(Design.params.buttonHeightSmall)
//
//         let acceptButton1 = ReactionButton<Design>()
//            .setAll {
//               $0.hidden(true)
//               $1.text("Подтвердить")
//            }
//            .height(Design.params.buttonHeightSmall)
         
         let acceptButton = ButtonModel()
            .set(Design.state.button.default)
            .title("Подтвердить")
            .font(Design.font.default)
            .padding(.sideOffset(Grid.x14.value))
            .height(Design.params.buttonHeightSmall)
            .cornerRadius(Design.params.cornerRadiusSmall)

         acceptButton.view.startTapGestureRecognize()
         rejectButton.view.startTapGestureRecognize()

         rejectButton.view.on(\.didTap, self) {
            $0.send(\.rejectPressed, reportId)
         }

         acceptButton.view.on(\.didTap, self) {
            $0.send(\.acceptPressed, reportId)
         }

         var buttonsStack = StackModel()
            .padding(.outline(Grid.x8.value))
            .spacing(Grid.x12.value)
            .axis(.horizontal)
            .alignment(.center)
            .distribution(.fill)
            .arrangedModels([
               rejectButton,
               acceptButton
            ])

         let cellStack = WrappedX(
            StackModel()
               .padding(Design.params.cellContentPadding)
               .spacing(Grid.x12.value)
               .alignment(.leading)
               .arrangedModels([
                  userInfo,
                  textLabel,
                  photo,
                  buttonsStack
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

extension ChallContendersPresenters: Eventable {
   struct Events: InitProtocol {
      var acceptPressed: Int?
      var rejectPressed: Int?
   }
}
