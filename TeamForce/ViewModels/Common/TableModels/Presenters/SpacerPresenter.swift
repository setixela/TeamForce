//
//  SpacerPresenter.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.08.2022.
//

import CoreGraphics

struct SpacerItem {
   let size: CGFloat
}

struct SpacerPresenter {
   static var presenter: Presenter<SpacerItem, Spacer> {
      Presenter { work in
         let item = work.unsafeInput.item
         work.success(result: Spacer(item.size))
      }
   }
}
