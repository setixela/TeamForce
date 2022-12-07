//
//  WorkingPlaceBlock.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.12.2022.
//

import ReactiveWorks

// MARK: - WorkingPlaceBlock

final class WorkingPlaceBlock<Design: DSP>: ProfileStackModel<Design> {
   private lazy var title = LabelModel()
      .set(Design.state.label.body1)
      .text("Место работы")

   private lazy var company = ProfileTitleBody<Design>
   { $0.title.text("Компания") }
   private lazy var jobTitle = ProfileTitleBody<Design>
   { $0.title.text("Должность") }

   override func start() {
      super.start()

      spacing(16)
      arrangedModels(
         title,
         company,
         jobTitle
      )
   }
}

extension WorkingPlaceBlock: StateMachine {
   func setState(_ state: UserWorkData) {
      company.setBody(state.company)
      jobTitle.setBody(state.jobTitle)
   }
}
