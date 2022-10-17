//
//  BarButtonModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import ReactiveWorks
import UIKit

struct BarButtonEvent: InitProtocol {
   var initWithImage: UIImage?
   var initiated: UIBarButtonItem?
   var didTap: Void?
}

final class BarButtonModel: BaseModel, Eventable {
   typealias Events = BarButtonEvent
   var events = [Int: LambdaProtocol?]()

   override func start() {
      on(\.initWithImage) { [weak self] image in
         self?.startWithImage(image)
      }
   }

   private func startWithImage(_ image: UIImage) {
      let menuItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTap))
      send(\.initiated, menuItem)
   }

   @objc func didTap() {
      send(\.didTap)
   }
}
