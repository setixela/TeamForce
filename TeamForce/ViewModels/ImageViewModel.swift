//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

final class ImageViewState: BaseClass, Setable {
    var image: UIImage?
    var size: CGSize?
}

final class ImageViewModel: BaseViewModel<UIImageView> {
    var state: ImageViewState = .init()

    override func start() {

    }
}

extension ImageViewModel: Stateable {

    func applyState() {
        view.image = state.image
        if let size = state.size {
            view.addAnchors
                .constWidth(size.width)
                .constHeight(size.height)
        }
    }
}
