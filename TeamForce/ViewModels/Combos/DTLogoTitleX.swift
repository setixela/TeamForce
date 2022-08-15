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
      set_image(Design.icon.logo)
      set_size(.square(34))
   }
}

final class DTLogoTitleX<Design: DesignProtocol>:
   Combos<SComboMR<BrandLogoIcon<Design>, ImageViewModel>>,
   Designable,
   Stateable2
{
   required init() {
      super.init()

      setMain { _ in } setRight: {
         $0
            .set_image(Design.icon.logoTitle)
            .set_width(120)
            .set_padding(.left(12))
            .set_contentMode(.scaleAspectFit)
      }
   }
}

extension DTLogoTitleX {
   func applyState(_ state: DTLogoTitleState) {
      switch state {
      case .normal:
         setMain { _ in } setRight: {
            $0
               .set_tintColor(Design.color.iconContrast)
         }
      case .invert:
         setMain { _ in } setRight: {
            $0
               .set_tintColor(Design.color.iconInvert)
         }
      }
   }
}
