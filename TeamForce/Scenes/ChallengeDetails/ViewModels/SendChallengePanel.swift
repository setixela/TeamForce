//
//  SendChallengePanel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 20.11.2022.
//

import ReactiveWorks

final class SendChallengePanel<Design: DSP>: StackModel, Designable {
   var sendButton: ButtonModel { buttons.models.main }
   var likeButton: ReactionButton<Design> { buttons.models.right }

   // Private

   private lazy var buttons = M<ButtonModel>.R<ReactionButton<Design>>.Combo()
      .setAll { sendButton, likeButton in
         sendButton
            .set(Design.state.button.default)
            .font(Design.font.body1)
            .title("Отправить результат")
            .hidden(true)
         likeButton
            .setAll {
               $0.image(Design.icon.like)
               $1
                  .font(Design.font.caption)
                  .text("0")
            }
            .removeAllConstraints()
            .width(68)
      }
      .spacing(8)

   override func start() {
      super.start()
      likeButton.view.startTapGestureRecognize()

      arrangedModels([
         Grid.x16.spacer,
         buttons
      ])
      alignment(.trailing)
   }
}
