//
//  ChallengeCellInfoBlock.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.11.2022.
//

import Foundation

final class ChallengeCellInfoBlock:
   M<TitleBodyY>
   .D<TitleBodyY>
   .D2<TitleBodyY>
   .D3<TitleBodyY>
   .Combo
{
   override func start() {
      super.start()

      alignment(.top)
      distribution(.equalSpacing)
   }
}
