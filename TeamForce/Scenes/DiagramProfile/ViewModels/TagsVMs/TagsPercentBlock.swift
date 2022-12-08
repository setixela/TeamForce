//
//  TagsPercentBlock.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.12.2022.
//

import ReactiveWorks
import Foundation

// MARK: - TagsPercentBlock

final class TagsPercentBlock<Design: DSP>: ProfileStackModel<Design> {
   private lazy var diagram = DiagramVM()
      .height(132)
   private lazy var tagsCloud = TagsPercentCloud<Design>()

   override func start() {
      super.start()

      spacing(16)
      arrangedModels(
         diagram,
         tagsCloud
      )
   }
}

extension TagsPercentBlock: StateMachine {
   func setState(_ state: [TagPercent]) {
      let circleColors = Design.color.iconBrand.colorsCircle(
         state.count,
         saturate: 0.3,
         bright: 0.8
      )
      let graphs = state.enumerated().map {
         let percent = self.percentToInt($1.percent)
         return GraphData(
            percent: $1.percent,
            text: "\(percent)%",
            color: circleColors[$0]
         )
      }

      let tags = state.enumerated().map {
         let percent = self.percentToInt($1.percent)
         return TagPercentCloudData(
            text: "\($1.name) \(percent)%",
            color: circleColors[$0]
         )
      }

      diagram.setState(graphs)
      tagsCloud.setState(tags)
   }

   private func percentToInt(_ percent: CGFloat) -> Int {
      Int((percent * 100).rounded(.toNearestOrAwayFromZero))
   }
}
