//
//  UserLocationBlock.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.12.2022.
//

import ReactiveWorks
import MapKit

// MARK: - UserLocationBlock

final class UserLocationBlock<Design: DSP>: ProfileStackModel<Design> {
   private lazy var title = LabelModel()
      .set(Design.state.label.body1)
      .text("Местоположение")

   private lazy var adress = ProfileTitleBody<Design>
   { $0.title.text("Адрес") }

   private lazy var map = MapsViewModel()
      .height(162)
      .cornerRadius(16)

   override func start() {
      super.start()

      spacing(16)
      arrangedModels(
         title,
         adress,
         map
      )
   }
}

extension UserLocationBlock: StateMachine {
   func setState(_ state: UserLocationData) {
      adress.setBody(state.locationName)
      let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
      let region = MKCoordinateRegion(center: state.geoPosition, span: span)
      map.setState(.region(region))
   }
}
