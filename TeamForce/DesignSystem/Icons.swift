//
//  Icons.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import ReactiveWorks
import UIKit

protocol IconsProtocol: InitProtocol,
   KeyPathMaker where MakeType: UIImage, ValueType == IconType
{
   associatedtype IconType

   // brand
   var logo: IconType { get }
   var logoTitle: IconType { get }
   // other
   var checkCircle: IconType { get }
   var coinLine: IconType { get }
   var historyLine: IconType { get }
   var upload2Fill: IconType { get }
   var calendarLine: IconType { get }

   var avatarPlaceholder: IconType { get }

   var sideMenu: IconType { get }

   var arrowDropDownLine: IconType { get }
   var arrowDropUpLine: IconType { get }


   var clapHands: IconType { get }

   var introlIllustrate: IconType { get }

   var girlOnSkateboard: IconType { get }

   var sendCoinIcon: IconType { get }
   var recieveCoinIcon: IconType { get }
}

struct Icons: IconsProtocol {
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
   func make(_ keypath: KeyPath<Self, IconType>) -> UIImage {
      let name = self[keyPath: keypath]
      return UIImage(named: name) ?? UIImage()
   }
}

protocol KeyPathMaker {
   associatedtype MakeType
   associatedtype ValueType

   func make(_ keypath: KeyPath<Self, ValueType>) -> MakeType
}
