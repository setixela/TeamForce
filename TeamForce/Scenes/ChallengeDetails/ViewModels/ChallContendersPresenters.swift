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
         
         let index = work.unsafeInput.index
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
            .image(Design.icon.newAvatar)
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
            let userIconText = String(name.first ?? "?") + String(surname.first ?? "?")
            DispatchQueue.global(qos: .background).async {
               let image = userIconText.drawImage(backColor: Design.color.backgroundBrand)
               DispatchQueue.main.async {
                  icon
                     .backColor(Design.color.backgroundBrand)
                     .image(image)
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
            .numberOfLines(0)
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
            .padding(.horizontalOffset(Grid.x14.value))
            .height(Design.params.buttonHeightSmall)
            .cornerRadius(Design.params.cornerRadiusSmall)
         
         let acceptButton = ButtonModel()
            .set(Design.state.button.default)
            .title("Подтвердить")
            .font(Design.font.default)
            .padding(.horizontalOffset(Grid.x14.value))
            .height(Design.params.buttonHeightSmall)
            .cornerRadius(Design.params.cornerRadiusSmall)

         rejectButton.view.on(\.didTap, self) {
            $0.send(\.rejectPressed, reportId)
         }

         acceptButton.view.on(\.didTap, self) {
            $0.send(\.acceptPressed, reportId)
         }

         let buttonsStack = StackModel()
            .padding(.outline(Grid.x8.value))
            .spacing(Grid.x12.value)
            .axis(.horizontal)
            .alignment(.center)
            .distribution(.fill)
            .arrangedModels([
               rejectButton,
               acceptButton
            ])
         
         let messageButton = ReactionButton<Design>()
            .setAll {
               $0.image(Design.icon.messageCloud)
               $1.text("")
            }

         let likeButton = ReactionButton<Design>()
            .setAll {
               $0.image(Design.icon.like)
               $1.text("")
            }

         likeButton.view.startTapGestureRecognize(cancelTouch: true)

         likeButton.view.on(\.didTap, self) {
            let body = PressLikeRequest.Body(
               likeKind: 1,
               challengeReportId: contender.reportId
            )
            let request = PressLikeRequest(
               token: "",
               body: body,
               index: index
            )
            $0.send(\.reactionPressed, request)

            likeButton.setState(.selected)
         }
         
         let reactionsBlock = StackModel()
            .axis(.horizontal)
            .alignment(.leading)
            .distribution(.fill)
            .spacing(4)
            .arrangedModels([
               messageButton,
               likeButton,
               Grid.xxx.spacer
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
                  buttonsStack,
                  reactionsBlock
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
      var reactionPressed: PressLikeRequest?
   }
}
