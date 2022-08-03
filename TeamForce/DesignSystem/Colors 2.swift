//
//  Colors.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.07.2022.
//

import Foundation
import UIKit

protocol ColorsProtocol: InitProtocol {
    var background: UIColor { get }
    var background1: UIColor { get }
    var background2: UIColor { get }
    var inactiveButton: UIColor { get }
}

struct Colors: ColorsProtocol {
    var background: UIColor { .white }
    var background1: UIColor { .init(white: 0.93, alpha: 1) }
    let background2 = UIColor(hex: 0xf3eafcff)
    let inactiveButton = UIColor(hex: 0xe9d5feff)
}

extension UIColor {
    convenience init(hex: Int) {
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
