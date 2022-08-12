//
//  LogoTitleSubtitleModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 07.08.2022.
//

import UIKit
import ReactiveWorks

// MARK: - LogoTitleSubtitleModel

final class IconTitleSubtitleModel: BaseViewModel<PaddingImageView>, Stateable2 {
   typealias State = ViewState
   typealias State2 = ImageViewState
   //
   let rightModel: TitleSubtitleModel = .init()
   //
}

extension IconTitleSubtitleModel: ComboRight {}
