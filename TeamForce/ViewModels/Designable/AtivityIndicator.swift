//
//  AtivityIndicator.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.09.2022.
//

import ReactiveWorks
import UIKit

final class ActivityIndicator<Design: DSP>: BaseViewModel<UIActivityIndicatorView>, Stateable {
   typealias State = ViewState

   override func start() {
      size(.square(100))
      view.startAnimating()
      view.color = Design.color.iconBrand
      view.contentScaleFactor = 1.33
   }
}

final class ActivityIndicatorSpacedBlock<Design: DSP>: M<ActivityIndicator<Design>>.D<Spacer>.Combo, Designable {
   required init() {
      super.init()

      setAll { _, _ in }
   }
}
