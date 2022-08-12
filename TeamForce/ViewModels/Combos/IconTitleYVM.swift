//
//  IconTitleYVM.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.08.2022.
//

import ReactiveWorks
import UIKit

class IconTitleYVM: Combos<SComboMR<ImageViewModel, LabelModel>> {
   let mainModel: ImageViewModel = .init()
   let rightModel: LabelModel = .init()
}
