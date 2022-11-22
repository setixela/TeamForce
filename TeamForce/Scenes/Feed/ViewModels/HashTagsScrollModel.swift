//
//  HashTagsScrollModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 03.10.2022.
//

import Foundation

final class HashTagsScrollModel<Design: DSP>: ScrollViewModelX, Designable {
   override func start() {
      super.start()
      
      set(.spacing(4))
      set(.hideHorizontalScrollIndicator)

      // TODO: - Временно
      userInterractionEnabled(true)
   }
}

extension HashTagsScrollModel: SetupProtocol {
   func setup(_ data: [FeedTag]?) {
      let tags = (data ?? []).map { tag in
         WrappedX(
            LabelModel()
               .set(Design.state.label.caption2)
               .text("# " + tag.name)
         )
         .backColor(Design.color.infoSecondary)
         .cornerRadius(Design.params.cornerRadiusMini)
         .padding(.outline(8))
      }

      set(.arrangedModels(tags))
   }
}
