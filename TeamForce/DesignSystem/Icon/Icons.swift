//
//  Icons.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import ReactiveWorks
import UIKit

struct Icons: IconElements {
   
   typealias DesignElement = String
   // brand
   var logo: String { "dt_logo" }
   var logoTitle: String { "dt_logo_title" }
   var introlIllustrate: String { "dt_main" }

   // other
   var upload2Fill: String { "upload-2-fill" }
   var coinLine: String { "coin-line" }
   var historyLine: String { "history-line" }
   var checkCircle: String { "check_circle_24px" }
   var calendarLine: String { "calendar-line" }

   var avatarPlaceholder: String { "avatarPlaceholder" }

   var sideMenu: String { "menu_24px" }

   var arrowDropDownLine: String { "arrow-drop-down-line" }
   var arrowDropUpLine: String { "arrow-drop-up-line" }

   var clapHands: String { "bloom_woman_and_man_clapped_their_hands_1" }

   var girlOnSkateboard: String { "girl_on_skateboard" }

   var recieveCoinIcon: String { "recieve_coin_icon" }
   var sendCoinIcon: String { "send_coin_icon" }
}

extension Icons: KeyPathMaker {
   func make(_ keypath: KeyPath<Self, String>) -> UIImage {
      let name = self[keyPath: keypath]
      return UIImage(named: name) ?? UIImage()
   }
}

protocol KeyPathMaker {
   associatedtype MakeType
   associatedtype ValueType

   func make(_ keypath: KeyPath<Self, ValueType>) -> MakeType
}
