//
//  Colors.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.07.2022.
//

import ReactiveWorks
import UIKit

// Протокол Фабрики цветов
protocol ColorsProtocol: InitProtocol {
    // Brand colors
    var brand: UIColor { get }

    // Text colors
    var textPrimary: UIColor { get }

    // Backs
    var background: UIColor { get }
    var background1: UIColor { get }
    var background2: UIColor { get }

    // Other
    var inactiveButton: UIColor { get }
    var error: UIColor { get }
    var activeButton: UIColor { get }
}

// Фабрика цветов
struct Colors: ColorsProtocol {
    var brand: UIColor { .init(0xB47CE8ff) }

    var textPrimary: UIColor { .black }
    var background: UIColor { .white }
    var background1: UIColor { .init(white: 0.93, alpha: 1) }
    var background2: UIColor { .init(0xf3eafcff) }
    var inactiveButton: UIColor { .init(0xe9d5feff) }
    var error: UIColor { .init(0xf0260bff) }
    var activeButton: UIColor { brand }
}

extension UIColor {
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
