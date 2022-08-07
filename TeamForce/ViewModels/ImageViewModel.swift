//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import ReactiveWorks
import UIKit

final class ImageViewModel: BaseViewModel<UIImageView> {
   override func start() {}
}

extension ImageViewModel: Stateable2 {
   typealias State = ViewState
   typealias State2 = ImageViewState
}
