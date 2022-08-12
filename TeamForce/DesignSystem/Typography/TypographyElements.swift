//
//  TypographyProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 10.07.2022.
//

import Foundation
import ReactiveWorks

protocol TypographyElements: InitProtocol, DesignElementable {
   var `default`: DesignElement { get }

   var headline2: DesignElement { get }
   var headline3: DesignElement { get }
   var headline4: DesignElement { get }
   var headline5: DesignElement { get }
   var headline6: DesignElement { get }

   var title: DesignElement { get }
   var body1: DesignElement { get }
   var body2: DesignElement { get }
   var subtitle: DesignElement { get }
   var caption: DesignElement { get }
   var counter: DesignElement { get }
}
