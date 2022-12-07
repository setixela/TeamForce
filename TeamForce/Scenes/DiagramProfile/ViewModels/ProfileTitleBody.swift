//
//  ProfileTitleBody.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 07.12.2022.
//

import ReactiveWorks

// MARK: - ProfileTitleBody

final class ProfileTitleBody<Design: DSP>: M<LabelModel>.D<LabelModel>.Combo, Designable {
   var title: LabelModel { models.main }

   func setBody(_ text: String?) {
      guard let text else { hidden(true); return }

      models.down.text(text)
      hidden(false)
   }

   required init() {
      super.init()

      setAll { title, body in
         title
            .set(Design.state.label.captionSecondary)
         body
            .set(Design.state.label.default)
      }

      spacing(8)
   }
}
