//
//  Icons.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import ReactiveWorks
import UIKit

protocol IconElements: InitProtocol, DesignElementable where DesignElement == UIImage {
   var attach: DesignElement { get }
   var bell: DesignElement { get }
   var calendar: DesignElement { get }
   var cross: DesignElement { get }
   var inProgress: DesignElement { get }
   var lock: DesignElement { get }
   var mail: DesignElement { get }
   var user: DesignElement { get }
   //
   var alarm: UIImage { get }
   var messageCloud: UIImage { get }
   var like: UIImage { get }
   var dislike: UIImage { get }
   // brand
   var logo: DesignElement { get }
   var logoTitle: DesignElement { get }
   var logoCurrency: UIImage { get }
   var logoCurrencyRed: UIImage { get }
   var logoCurrencyBig: UIImage { get }

   // other
   var checkCircle: DesignElement { get }
   var coinLine: DesignElement { get }
   var coinBackground: DesignElement { get }
   var historyLine: DesignElement { get }
   var upload2Fill: DesignElement { get }
   var calendarLine: DesignElement { get }

   var avatarPlaceholder: DesignElement { get }
   var newAvatar: DesignElement { get }
   var challengeAvatar: DesignElement { get }
   var anonAvatar: DesignElement { get }

   var sideMenu: DesignElement { get }

   var arrowDropDownLine: DesignElement { get }
   var arrowDropUpLine: DesignElement { get }
   var arrowDropRightLine: DesignElement { get }

   var clapHands: DesignElement { get }

   var introlIllustrate: DesignElement { get }

   var sendCoinIcon: DesignElement { get }
   var recieveCoinIcon: DesignElement { get }

   var burn: DesignElement { get }

   // bottom panel
   var bottomPanel: DesignElement { get }
   var tabBarMainButton: DesignElement { get }
   var tabBarButton1: DesignElement { get }
   var tabBarButton2: DesignElement { get }
   var tabBarButton3: DesignElement { get }
   var tabBarButton4: DesignElement { get }

   // transact
   var transactSuccess: DesignElement { get }
   var userNotFound: DesignElement { get }

   // profile
   var editCircle: DesignElement { get }
   var camera: DesignElement { get }

   // errors
   var errorIllustrate: DesignElement { get }

   // tabler
   var tablerCircleCheck: DesignElement { get }
   var tablerDiamond: DesignElement { get }
   var tablerChevronRight: DesignElement { get }
   var tablerCamera: DesignElement { get }
   var tablerMark: DesignElement { get }
   var tablerBrandTelegram: DesignElement { get }
   var tablerClock: DesignElement { get }
   var tablerGift: DesignElement { get }
   var tablerAward: DesignElement { get }

   var tablerRefresh: DesignElement { get }
   var tablerUserCheck: DesignElement { get }
   var tablerMessageCircle: DesignElement { get }
   var tablerMoodSmile: DesignElement { get }

   var tablerChess: DesignElement { get }
   var tablerBrandRedhat: DesignElement { get }
   var uilShieldSlash: DesignElement { get }
   var tablerUsers: DesignElement { get }
   var tablerWalk: DesignElement { get }
   var tablerRocket: DesignElement { get }
   var tablerRobot: DesignElement { get }
   var tablerHistory: DesignElement { get }
   var tablerSmartHome: DesignElement { get }
   var tablerSettings: DesignElement { get }
   var tablerPlus: DesignElement { get }
   var tablerBell: DesignElement { get }
   var tablerCreditCard: DesignElement { get }
   var tablerHeartPlus: DesignElement { get }
   var tablerLogin: DesignElement { get }
   var tablerLogout: DesignElement { get }
   var tablerEditCircle: DesignElement { get }
   var tablerArrowBackUp: DesignElement { get }
   var tablerInfoCircle: DesignElement { get }
   var tablerMailOpened: DesignElement { get }
   var tablerArrowLeft: DesignElement { get }
   var tablerCameraRotate: DesignElement { get }
   var tablerCameraOff: DesignElement { get }
   var tablerKeyboardShow: DesignElement { get }
   var tablerKeyboard: DesignElement { get }
   var tablerFilter: DesignElement { get }
   var tablerChevronDown: DesignElement { get }
   var tablerAlertCircle: DesignElement { get }
   var tablerWifiOff: DesignElement { get }
   var tablerSearch: DesignElement { get }
   var tablerCalendar: DesignElement { get }
   var tablerChevronUp: DesignElement { get }
   var tablerBrandSnapchat: DesignElement { get }
   var tablerHeartbeat: DesignElement { get }
   var tablerBuildingArch: DesignElement { get }
   var tablerDevicesPc: DesignElement { get }
   var tablerAerialLift: DesignElement { get }
   var tablerUser: DesignElement { get }
   var tablerPhone: DesignElement { get }
   var tablerMapIn: DesignElement { get }
   var tablerBriefcase: DesignElement { get }
   var tablerLayoutDashboard: DesignElement { get }

   // illusttrates
   var challengeWinnerIllustrateFull: DesignElement { get }
   var challengeWinnerIllustrate: DesignElement { get }

   // challenges
   var strangeLogo: DesignElement { get }
}

struct IconBuilder: IconElements {
   typealias DesignElement = UIImage

   var attach: UIImage { make("akar-icons_attach") }
   var bell: UIImage { make("bell") }
   var calendar: UIImage { make("calendar") }
   var cross: UIImage { make("tabler_mark") }
   var inProgress: UIImage { make("in_progress") }
   var lock: UIImage { make("lock") }
   var mail: UIImage { make("mail") }

   var user: UIImage { make("user") }

   var alarm: UIImage { make("alarm") }
   var messageCloud: UIImage { make("message_cloud") }
   var like: UIImage { make("like") }
   var dislike: UIImage { make("dislike") }

   // brand
   var logo: UIImage { make("dt_logo") }
   var logoTitle: UIImage { make("dt_logo_title") }
   var logoCurrency: UIImage { make("dt_currency_logo") }
   var logoCurrencyRed: UIImage { make("dt_currency_logo_red") }
   var logoCurrencyBig: UIImage { make("dt_currency_logo_big") }
   var introlIllustrate: UIImage { make("dt_main") }

   // other
   var upload2Fill: UIImage { make("upload-2-fill") }
   var coinLine: UIImage { make("coin-line") }
   var coinBackground: DesignElement { make("coin-background") }

   var historyLine: UIImage { make("history-line") }
   var checkCircle: UIImage { make("check_circle_24px") }
   var calendarLine: UIImage { make("calendar-line") }

   var avatarPlaceholder: UIImage { make("avatar") }
   var newAvatar: UIImage { make("avatar") }
   var challengeAvatar: UIImage { make("challengeAvatar") }
   var anonAvatar: UIImage { make("anon_avatar") }

   var sideMenu: UIImage { make("menu_24px") }

   var arrowDropDownLine: UIImage { make("arrow-drop-down-line") }
   var arrowDropUpLine: UIImage { make("arrow-drop-up-line") }
   var arrowDropRightLine: UIImage { make("arrow-drop-right-line") }

   var clapHands: UIImage { make("bloom_woman_and_man_clapped_their_hands_1") }

   var recieveCoinIcon: UIImage { make("recieve_coin_icon") }
   var sendCoinIcon: UIImage { make("send_coin_icon") }

   var burn: UIImage { make("burn") }

   var bottomPanel: UIImage { make("bottom_panel") }

   var tabBarMainButton: UIImage { make("dt_tabbar_main_button") }
   var tabBarButton1: UIImage { make("tabler_smart-home") }
   var tabBarButton2: UIImage { make("tabler_credit-card") }
   var tabBarButton3: UIImage { make("tabler_history") }
   var tabBarButton4: UIImage { make("tabler_settings") }

   // transact
   var transactSuccess: UIImage { make("dt_transact_success") }
   var userNotFound: UIImage { make("dt_not_found") }

   // profile
   var editCircle: UIImage { make("edit_circle") }
   var camera: UIImage { make("tabler_camera") }

   // errors
   var errorIllustrate: UIImage { make("dt_error_illustrate") }

   // tabler
   var tablerCircleCheck: UIImage { make("tabler_circle-check") }
   var tablerDiamond: UIImage { make("tabler_diamond") }
   var tablerChevronRight: UIImage { make("tabler_chevron-right") }
   var tablerCamera: UIImage { make("tabler_camera") }
   var tablerMark: UIImage { make("tabler_mark") }
   var tablerBrandTelegram: UIImage { make("tabler_brand-telegram") }
   var tablerClock: UIImage { make("tabler_clock") }
   var tablerGift: UIImage { make("tabler_gift") }
   var tablerAward: UIImage { make("tabler_award") }

   var tablerChess: UIImage { make("tabler_chess") }
   var tablerBrandRedhat: UIImage { make("tabler_brand-redhat") }
   var uilShieldSlash: UIImage { make("uil_shield-slash") }
   var tablerUsers: UIImage { make("tabler_users") }
   var tablerWalk: UIImage { make("tabler_walk") }
   var tablerRocket: UIImage { make("tabler_rocket") }
   var tablerRobot: UIImage { make("tabler_robot") }
   var tablerHistory: UIImage { make("tabler_history") }
   var tablerSmartHome: UIImage { make("tabler_smart-home") }
   var tablerSettings: UIImage { make("tabler_settings") }
   var tablerPlus: UIImage { make("tabler_plus") }
   var tablerBell: UIImage { make("tabler_bell") }
   var tablerCreditCard: UIImage { make("tabler_credit-card") }
   var tablerHeartPlus: UIImage { make("tabler_heart-plus") }
   var tablerLogin: UIImage { make("tabler_login") }
   var tablerLogout: UIImage { make("tabler_logout") }
   var tablerEditCircle: UIImage { make("tabler_edit-circle") }
   var tablerArrowBackUp: UIImage { make("tabler_arrow-back-up") }
   var tablerInfoCircle: UIImage { make("tabler_info-circle") }
   var tablerMailOpened: UIImage { make("tabler_mail-opened") }
   var tablerArrowLeft: UIImage { make("tabler_arrow-left") }
   var tablerCameraRotate: UIImage { make("tabler_camera-rotate") }
   var tablerCameraOff: UIImage { make("tabler_camera-off") }
   var tablerKeyboardShow: UIImage { make("tabler_keyboard-show") }
   var tablerKeyboard: UIImage { make("tabler_keyboard") }
   var tablerFilter: UIImage { make("tabler_filter") }
   var tablerChevronDown: UIImage { make("tabler_chevron-down") }
   var tablerAlertCircle: UIImage { make("tabler_alert-circle") }
   var tablerWifiOff: UIImage { make("tabler_wifi-off") }
   var tablerSearch: UIImage { make("tabler_search") }
   var tablerCalendar: UIImage { make("tabler_calendar") }
   var tablerChevronUp: UIImage { make("tabler_chevron-up") }
   var tablerBrandSnapchat: UIImage { make("tabler_brand-snapchat") }
   var tablerHeartbeat: UIImage { make("tabler_heartbeat") }
   var tablerBuildingArch: UIImage { make("tabler_building-arch") }
   var tablerDevicesPc: UIImage { make("tabler_devices-pc") }
   var tablerAerialLift: UIImage { make("tabler_aerial-lift") }
   var tablerUser: UIImage { make("tabler_user") }
   var tablerPhone: UIImage { make("tabler_phone") }
   var tablerMapIn: UIImage { make("tabler_map-pin") }
   var tablerBriefcase: UIImage { make("tabler_briefcase") }
   var tablerLayoutDashboard: UIImage { make("tabler_layout-dashboard") }

   var tablerRefresh: UIImage { make("tabler_refresh") }
   var tablerUserCheck: UIImage { make("tabler_user-check") }
   var tablerMessageCircle: UIImage { make("tabler_message-circle-2") }
   var tablerMoodSmile: UIImage { make("tabler_mood-smile") }

   // illusttrates
   var challengeWinnerIllustrateFull: UIImage { make("challenge_winner_illustrate_full") }
   var challengeWinnerIllustrate: UIImage { make("challenge_winner_illustrate") }

   // challenges
   var strangeLogo: UIImage { make("strange_icon") }
}

private extension IconBuilder {
   func make(_ name: String) -> UIImage {
      UIImage(named: name) ?? {
         print("\n##### Image named: \(name) not found! #####\n")
         return UIImage()
      }()
   }
}
