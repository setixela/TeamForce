//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit
import ReactiveWorks

enum ImageViewState {
    case image(UIImage)
    case contentMode(UIView.ContentMode)
}

final class ImageViewModel: BaseViewModel<UIImageView> {
    override func start() {}
}

extension ImageViewModel: Stateable2 {

    typealias State = ViewState

    func applyState(_ state: ImageViewState) {
        switch state {
        case .image(let uIImage):
            view.image = uIImage
        case .contentMode(let mode):
            view.contentMode = mode
        }
    }
}
