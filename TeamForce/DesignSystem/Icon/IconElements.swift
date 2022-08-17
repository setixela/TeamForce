//
//  IconElements.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 13.08.2022.
//

import ReactiveWorks
import UIKit

protocol IconElements: InitProtocol, DesignElementable where DesignElement == UIImage {
   var bell: DesignElement { get }
   var calendar: DesignElement { get }
   var lock: DesignElement { get }
   var mail: DesignElement { get }
   var user: DesignElement { get }
   // brand
   var logo: DesignElement { get }
   var logoTitle: DesignElement { get }
   // other
   var checkCircle: DesignElement { get }
   var coinLine: DesignElement { get }
   var historyLine: DesignElement { get }
   var upload2Fill: DesignElement { get }
   var calendarLine: DesignElement { get }

   var avatarPlaceholder: DesignElement { get }

   var sideMenu: DesignElement { get }

   var arrowDropDownLine: DesignElement { get }
   var arrowDropUpLine: DesignElement { get }

   var clapHands: DesignElement { get }

   var introlIllustrate: DesignElement { get }

   var girlOnSkateboard: DesignElement { get }

   var sendCoinIcon: DesignElement { get }
   var recieveCoinIcon: DesignElement { get }

   // bottom panel
   var bottomPanel: DesignElement { get }
   var tabBarMainButton: DesignElement { get }
   var tabBarButton1: UIImage { get }
   var tabBarButton2: UIImage { get }
   var tabBarButton3: UIImage { get }
   var tabBarButton4: UIImage { get }
}
