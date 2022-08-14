//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.08.2022.
//

import ReactiveWorks

final class DTLogoTitleX<Asset: AssetProtocol>:
   Combos<SComboMR<ImageViewModel, ImageViewModel>>,
   Assetable
{
   required init() {
      super.init()

      setMain {
         $0
            .set(.image(Design.icon.logo))
            .set(.size(.square(34)))

      } setRight: {
         $0
            .set(.image(Design.icon.logoTitle))
            .set(.width(120))
            .set(.padding(.left(12)))
            .set(.contentMode(.scaleAspectFit))
      }
   }
}
