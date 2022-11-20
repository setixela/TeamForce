//
//  ChallengeStatusBlock.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 20.11.2022.
//

import ReactiveWorks

final class ChallengeStatusBlock<Design: DSP>: LabelModel, Designable {
   override func start() {
      font(Design.font.caption)
      backColor(Design.color.backgroundInfoSecondary)
      height(36)
      cornerRadius(36 / 2)
      padding(.horizontalOffset(12))
      textColor(Design.color.textInfo)
   }
}
