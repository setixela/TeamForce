//
//  ProfileStackModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 07.12.2022.
//

import ReactiveWorks
import UIKit

// MARK: - ProfileStackModel

class ProfileStackModel<Design: DSP>: StackModel, Designable {
   override func start() {
      super.start()

      backColor(Design.color.background)
      padding(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
      cornerRadius(Design.params.cornerRadiusMedium)
      shadow(Design.params.cellShadow)
   }
}
