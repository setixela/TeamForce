//
//  MainSceneEvents.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 26.08.2022.
//

import CoreGraphics
import ReactiveWorks

struct MainSceneEvents: InitProtocol {
   var didScroll: Event<CGFloat>?
   var willEndDragging: Event<CGFloat>?
   var didAppear: Event<Void>?
}
