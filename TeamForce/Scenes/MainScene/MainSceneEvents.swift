//
//  MainSceneEvents.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 26.08.2022.
//

import CoreGraphics
import ReactiveWorks

struct MainSceneEvents: InitProtocol {
   var didScroll: CGFloat?
   var willEndDragging: CGFloat?
   var userDidLoad: UserData??
}
