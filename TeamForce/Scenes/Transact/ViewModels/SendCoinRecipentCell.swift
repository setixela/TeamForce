//
//  SendCoinRecipentCell.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 03.09.2022.
//

import Foundation

final class SendCoinRecipentCell<Design: DSP>:
   M<ImageViewModel>.R<LabelModel>.D<LabelModel>.R2<CurrencyLabelDT<Design>>.Combo
{
   required init() {
      super.init()

      setAll { avatar, userName, nickName, amount in
         avatar
            .size(.square(44))
            .cornerRadius(44 / 2)
            .contentMode(.scaleAspectFill)
         userName
            .set(Design.state.label.body4)
            .alignment(.left)
         nickName
            .set(Design.state.label.captionSecondary)
            .alignment(.left)
         amount.label
            .height(Grid.x32.value)
            .set(Design.state.label.headline4)
            .textColor(Design.color.textError)
         amount.currencyLogo
            .width(22)
      }
      .padding(.outline(Grid.x16.value))
      .backColor(Design.color.background)
      .cornerRadius(Design.params.cornerRadius)
      .shadow(Design.params.cellShadow)
      .borderColor(.black)
      .alignment(.center)
      .distribution(.equalSpacing)
   }
}
