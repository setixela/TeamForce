//
//  ButtonElements.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 13.08.2022.
//

import ReactiveWorks

protocol ButtonElements: InitProtocol, DesignElementable {

   var `default`: DesignElement { get }
   var transparent: DesignElement { get }
   var inactive: DesignElement { get }

   var tabBar: DesignElement { get }
}
