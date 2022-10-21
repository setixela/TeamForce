//
//  ChallReportDetailsViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 20.10.2022.
//

import ReactiveWorks

final class ChallReportDetailsVM<Design: DSP>: StackModel, Designable {
   lazy var title = Design.label.headline6
   lazy var body = Design.label.caption
      .numberOfLines(0)
      .lineSpacing(8)
   
   let photo = ImageViewModel()
      .image(Design.icon.transactSuccess)
      .height(250)
      .width(250)
      .contentMode(.scaleAspectFill)
      .cornerRadius(Design.params.cornerRadiusSmall)
      .hidden(true)
   
   override func start() {
      super.start()
      
   }
}

extension ChallReportDetailsVM: SetupProtocol {
   func setup(_ report: ChallengeReport) {
      title.text(report.challenge.name.string)
      body.text(report.text.string)
      
      
      if let photoLink = report.photo {
         photo.url(TeamForceEndpoints.urlBase + photoLink, )
         photo.hidden(false)
      }
   }
}
