//
//  Icons.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import ReactiveWorks
import UIKit

struct IconBuilder: IconElements {
   typealias DesignElement = UIImage

   // brand
   var logo: UIImage { make("dt_logo") }
   var logoTitle: UIImage { make("dt_logo_title") }
   var introlIllustrate: UIImage { make("dt_main") }

   // other
   var upload2Fill: UIImage { make("upload-2-fill") }
   var coinLine: UIImage { make("coin-line") }
   var historyLine: UIImage { make("history-line") }
   var checkCircle: UIImage { make("check_circle_24px") }
   var calendarLine: UIImage { make("calendar-line") }

   var avatarPlaceholder: UIImage { make("avatarPlaceholder") }

   var sideMenu: UIImage { make("menu_24px") }

   var arrowDropDownLine: UIImage { make("arrow-drop-down-line") }
   var arrowDropUpLine: UIImage { make("arrow-drop-up-line") }

   var clapHands: UIImage { make("bloom_woman_and_man_clapped_their_hands_1") }

   var girlOnSkateboard: UIImage { make("girl_on_skateboard") }

   var recieveCoinIcon: UIImage { make("recieve_coin_icon") }
   var sendCoinIcon: UIImage { make("send_coin_icon") }

   //
   private func make(_ name: String) -> UIImage {
      UIImage(named: name) ?? UIImage()
   }
}