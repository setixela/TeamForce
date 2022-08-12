//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.08.2022.
//

import ReactiveWorks

final class DTLogoTitleXVM<Asset: AssetProtocol>:
   Combos<SComboMR<ImageViewModel, ImageViewModel>>,
   Assetable
{
   override func start() {
      setMain {
         $0
            .set(.image(Design.icon.make(\.logo)))
            .set(.size(.square(36)))

      } setRight: {
         $0
            .set(.image(Design.icon.make(\.logoTitle)))
            .set(.padding(.init(top: 8, left: 12, bottom: 4, right: 0)))
      }
   }
}
