//
//  ChallengeInfoVM.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 20.11.2022.
//

import ReactiveWorks

final class ChallengeInfoVM<Design: DSP>: StackModel, Designable {
   lazy var title = Design.label.headline6
      .numberOfLines(0)
   lazy var body = Design.label.default
      .numberOfLines(0)
      .lineSpacing(8)
   lazy var tags = StackModel()
      .spacing(8)

   override func start() {
      super.start()

      arrangedModels([
         title,
         Spacer(12),
         body,
         Spacer(12),
         tags
      ])
      backColor(Design.color.background)
      distribution(.equalSpacing)
      alignment(.leading)
      padding(.outline(16))
      cornerRadius(Design.params.cornerRadiusSmall)
      shadow(Design.params.cellShadow)
   }
}

extension ChallengeInfoVM: SetupProtocol {
   func setup(_ data: Challenge) {
      title.text(data.name.string)
      body.text(data.description.string)
      let arrayOfStates = data.status?.components(separatedBy: ", ")
      let states = arrayOfStates?.map { ChallengeStatusBlock<Design>().text($0) }
      tags.arrangedModels(states ?? [])
   }
}
