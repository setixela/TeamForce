//
//  BadgeProtocols.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 11.08.2022.
//

import Foundation

protocol BadgeTop {
   associatedtype TB
   var topBadge: TB { get }
}

protocol BadgeBottom {
   associatedtype BB
   var bottomBadge: BB { get }
}
