//
//  BarButtonModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import UIKit
import ReactiveWorks

struct BarButtonEvent: InitProtocol {
    var initWithImage: Event<UIImage>?
    var initiated: Event<UIBarButtonItem>?
    var didTap: Event<Void>?
}

final class BarButtonModel: BaseModel, Communicable {
    var eventsStore = BarButtonEvent()

    override func start() {
        onEvent(\.initWithImage) { [weak self] image in
            self?.startWithImage(image)
        }
    }

    private func startWithImage(_ image: UIImage) {
        let menuItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTap))
        sendEvent(\.initiated, menuItem)
    }

    @objc func didTap() {
        sendEvent(\.didTap)
    }
}
