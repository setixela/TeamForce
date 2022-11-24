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
      image(Design.icon.logo)
      size(.square(34))
      cornerRadius(34/2)
      backColor(Design.color.backgroundBrandSecondary)
      imageTintColor(Design.color.iconBrand)
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
            .image(Design.icon.logoTitle)
            .imageTintColor(Design.color.iconBrand)
            .width(120)
            .padding(.left(12))
            .contentMode(.scaleAspectFit)
      }
   }
}

extension DTLogoTitleX {
   func applyState(_ state: DTLogoTitleState) {
      switch state {
      case .normal:
         setMain { _ in } setRight: {
            $0
               .imageTintColor(Design.color.iconContrast)
         }
      case .invert:
         setMain { _ in } setRight: {
            $0
               .imageTintColor(Design.color.iconInvert)
         }
      }
   }
}
