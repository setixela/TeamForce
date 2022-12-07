//
//  TagsPercentBlock.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.12.2022.
//

import ReactiveWorks

// MARK: - TagsPercentBlock

final class TagsPercentBlock<Design: DSP>: ProfileStackModel<Design> {
   private lazy var diagram = DiagramVM()
      .height(132)
   private lazy var tagsCloud = TagsPercentCloud<Design>()

   override func start() {
      super.start()

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
         saturate: 0.55,
         bright: 0.8
      )
      let graphs = state.enumerated().map {
         GraphData(percent: $1.percent, color: circleColors[$0])
      }

      let tags = state.enumerated().map {
         let percent = Int(($1.percent * 100).rounded(.toNearestOrAwayFromZero))
         return TagPercentCloudData(
            text: "\($1.name) \(percent)%",
            color: circleColors[$0]
         )
      }

      diagram.setState(graphs)
      tagsCloud.setState(tags)
   }
}
