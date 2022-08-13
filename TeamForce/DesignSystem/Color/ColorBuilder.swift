//
//  Colors.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.07.2022.
//

import ReactiveWorks
import UIKit

// Протокол Фабрики цветов ( Разнести потом палитру и детали и обьекты)
protocol ColorsElements: InitProtocol {
    // Brand colors
    var brand: UIColor { get }
    var transparent: UIColor { get }

    // Text colors
    var text: UIColor { get }
    var text2: UIColor { get }

    var textInvert: UIColor { get }
    var text2Invert: UIColor { get }

    // Backs
    var background: UIColor { get }
    var background2: UIColor { get }
    var background3: UIColor { get }

    // Errors
    var error: UIColor { get }

    // Other
    var inactiveButton: UIColor { get }
    var activeButton: UIColor { get }
    var transparentButton: UIColor { get }
    // textfields
    var textFieldBack: UIColor { get }
}

// Фабрика цветов
struct ColorBuilder: ColorsElements {
    var brand: UIColor { .init(0xb47ce8ff) }
    var transparent: UIColor { .clear }

    var text: UIColor { .black }
    var text2: UIColor { .black.withAlphaComponent(0.85) }

    var textInvert: UIColor { .white }
    var text2Invert: UIColor { .white.withAlphaComponent(0.85) }

    var background: UIColor { .white }
    var background2: UIColor { .init(0xf2e7feff) }
    var background3: UIColor { .init(0xb9a0d0ff) }

    var error: UIColor { .init(0xff0b0bff) }

    // button colors
    var activeButton: UIColor { brand }
    var inactiveButton: UIColor { background2 }
    var transparentButton: UIColor { transparent }
    var textFieldBack: UIColor { background }
}

private extension UIColor {
    convenience init(_ hex: Int) {
        let components = (
            r: CGFloat((hex >> 24) & 0xff) / 255,
            g: CGFloat((hex >> 16) & 0xff) / 255,
            b: CGFloat((hex >> 08) & 0xff) / 255,
            a: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(
            red: components.r,
            green: components.g,
            blue: components.b,
            alpha: components.a
        )
    }
}
