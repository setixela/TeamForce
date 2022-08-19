//
//  SideBarUserModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import ReactiveWorks
import UIKit

struct SideBarUserModelEvent: InitProtocol {
   var didTap: Event<Void>?
}

final class SideBarUserModel<Design: DesignProtocol>: BaseViewModel<StackViewExtended>,
   Communicable,
   Stateable2,
   Designable
{
   typealias State = StackState
   typealias State2 = ViewState

   var eventsStore: SideBarUserModelEvent = .init()

   lazy var avatar = ImageViewModel()
      .set(.size(.init(width: 64, height: 64)))

   lazy var userName = Design.label.headline6
   lazy var nickName = Design.label.body2

   override func start() {
      set(.axis(.vertical))
         .set(.distribution(.equalSpacing))
         .set(.alignment(.leading))
         .set(.padding(.init(top: 12, left: 16, bottom: 12, right: 16)))
         .set(.models([
            self.avatar,
            Spacer(30),
            self.userName,
            Spacer(4),
            self.nickName
         ]))

      let gesture = UITapGestureRecognizer(target: self, action: #selector(self.clickAction(sender:)))
      view.addGestureRecognizer(gesture)
   }

   @objc func clickAction(sender: UITapGestureRecognizer) {
      sendEvent(\.didTap)
   }
}
