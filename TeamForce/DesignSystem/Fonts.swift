//
//  Fonts.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 10.07.2022.
//

import UIKit
import ReactiveWorks

protocol FontProtocol: InitProtocol, TypographyElements where DesignElement == UIFont {}

struct FontBuilder: FontProtocol {
    var `default`: UIFont { .systemFont(ofSize: 14, weight: .regular) }

    var headline2: UIFont { .systemFont(ofSize: 60, weight: .regular) }
    var headline3: UIFont { .systemFont(ofSize: 48, weight: .regular) }
    var headline4: UIFont { .systemFont(ofSize: 34, weight: .regular) }
    var headline5: UIFont { .systemFont(ofSize: 24, weight: .regular) }
    var headline6: UIFont { .systemFont(ofSize: 20, weight: .regular) }

    var title: UIFont { .systemFont(ofSize: 24, weight: .bold) }

    var body1: UIFont { .systemFont(ofSize: 16, weight: .regular) }
    var body2: UIFont { .systemFont(ofSize: 14, weight: .regular) }

    var subtitle: UIFont { .systemFont(ofSize: 16, weight: .regular) }
    var caption: UIFont { .systemFont(ofSize: 12, weight: .regular) }
    var counter: UIFont { .systemFont(ofSize: 48, weight: .regular) }
}
