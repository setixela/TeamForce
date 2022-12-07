//
//  TagsPercentCloud.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.12.2022.
//

import ReactiveWorks
import UIKit

// MARK: - Tag Percent Cloud

struct TagPercentCloudData {
   let text: String
   let color: UIColor
}

final class TagsPercentCloud<Design: DSP>: StackModel, Designable {
   override func start() {
      spacing(8)
      alignment(.leading)
   }
}

extension TagsPercentCloud: StateMachine {
   func setState(_ state: [TagPercentCloudData]) {
      var currStack = StackModel()
         .axis(.horizontal)
         .spacing(4)
      var tagButts: [UIViewModel] = []
      let width = view.frame.width /// 1.5
      var currWidth: CGFloat = 0
      let spacing: CGFloat = 4

      state.enumerated().forEach { ind, tag in
         let button = LabelModel()
            .set(Design.state.label.default)
            .text(tag.text)
            .textColor(Design.color.textInvert)
            .backColor(tag.color)
            .padding(.horizontalOffset(12))
            .height(30)
            .cornerRadius(Design.params.cornerRadiusSmall)

         currStack.addArrangedModels([button])
         self.view.layoutIfNeeded()
         let butWidth = button.uiView.frame.width

         currWidth += butWidth + spacing

         let isNotFit = currWidth > width
         if isNotFit || (ind == state.count - 1) {
            tagButts.append(currStack)
            currStack.removeLastModel()
            currStack = StackModel()
               .axis(.horizontal)
               .spacing(4)
            currStack.addArrangedModels([button])
            currWidth = 0
         }
      }

      arrangedModels(tagButts)
   }
}
