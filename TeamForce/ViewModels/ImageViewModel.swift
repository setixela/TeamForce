//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

enum ImageViewState {
    case image(UIImage)
    case size(CGSize)
    case contentMode(UIView.ContentMode)
}

final class ImageViewModel: BaseViewModel<UIImageView> {
 //   var state: ImageViewState = .init()

    override func start() {

    }
}

extension ImageViewModel: Stateable {

    func applyState(_ state: ImageViewState) {
        switch state {
        case .image(let uIImage):
            view.image = uIImage
        case .size(let cGSize):
            view.addAnchors
                .constWidth(cGSize.width)
                .constHeight(cGSize.height)
        case .contentMode(let mode):
            view.contentMode = mode
        }
    }
}
