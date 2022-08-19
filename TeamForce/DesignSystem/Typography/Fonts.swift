//
//  Fonts.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 10.07.2022.
//

import ReactiveWorks
import UIKit

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
   var body3: DesignElement { get }

   var subtitle: DesignElement { get }
   var caption: DesignElement { get }
   var counter: DesignElement { get }
}

protocol FontProtocol: TypographyElements where DesignElement == UIFont {}

struct FontBuilder: FontProtocol {
   var `default`: UIFont { .systemFont(ofSize: 14, weight: .regular) }

   var headline2: UIFont { .systemFont(ofSize: 60, weight: .regular) }
   var headline3: UIFont { .systemFont(ofSize: 48, weight: .regular) }
   var headline4: UIFont { .systemFont(ofSize: 32, weight: .bold) }
   var headline5: UIFont { .systemFont(ofSize: 28, weight: .bold) }
   var headline6: UIFont { .systemFont(ofSize: 20, weight: .regular) }

   var title: UIFont { .systemFont(ofSize: 24, weight: .bold) }

   var body1: UIFont { .systemFont(ofSize: 16, weight: .regular) }
   var body2: UIFont { .systemFont(ofSize: 14, weight: .semibold) }
   var body3: UIFont { .systemFont(ofSize: 16, weight: .semibold) }

   var subtitle: UIFont { .systemFont(ofSize: 16, weight: .regular) }
   var caption: UIFont { .systemFont(ofSize: 12, weight: .regular) }
   var counter: UIFont { .systemFont(ofSize: 48, weight: .regular) }
}