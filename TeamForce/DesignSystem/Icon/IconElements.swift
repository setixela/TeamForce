//
//  IconElements.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 13.08.2022.
//

import ReactiveWorks
import UIKit

protocol IconElements: InitProtocol, DesignElementable where DesignElement == UIImage {
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
}
