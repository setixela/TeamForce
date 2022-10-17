//
//  IconTitleYVM.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.08.2022.
//

import ReactiveWorks
import UIKit

class IconTitleX: Combos<SComboMR<ImageViewModel, LabelModel>> {
   var icon: ImageViewModel { models.main }
   var label: LabelModel { models.right }
}

class TitleIconX: Combos<SComboMR<LabelModel, ImageViewModel>> {
   var label: LabelModel { models.main }
   var icon: ImageViewModel { models.right }
}


class IconTitleY: Combos<SComboMD<ImageViewModel, LabelModel>> {
   var icon: ImageViewModel { models.main }
   var label: LabelModel { models.down }
}

class TitleIconY: Combos<SComboMD<LabelModel, ImageViewModel>> {
   var label: LabelModel { models.main }
   var icon: ImageViewModel { models.down }
}
