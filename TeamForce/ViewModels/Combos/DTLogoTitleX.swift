//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.08.2022.
//

import ReactiveWorks

enum DTLogoTitleState {
   case normal
   case invert
}

final class BrandLogoIcon<Design: DesignProtocol>: BaseViewModel<PaddingImageView>, Stateable {
   typealias State = ImageViewState

   override func start() {
      setImage(Design.icon.logo)
      setSize(.square(34))
   }
}

final class DTLogoTitleX<Design: DesignProtocol>:
   Combos<SComboMR<BrandLogoIcon<Design>, ImageViewModel>>,
   Designable,
   Stateable
{
   required init() {
      super.init()

      setMain { _ in } setRight: {
         $0
            .setImage(Design.icon.logoTitle)
            .setWidth(120)
            .setPadding(.left(12))
            .setContentMode(.scaleAspectFit)
      }
   }
}

extension DTLogoTitleX {
   func applyState(_ state: DTLogoTitleState) {
      switch state {
      case .normal:
         setMain { _ in } setRight: {
            $0
               .setTintColor(Design.color.iconContrast)
         }
      case .invert:
         setMain { _ in } setRight: {
            $0
               .setTintColor(Design.color.iconInvert)
         }
      }
   }
}
