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
    var errorColor: UIColor { get }
}

struct Colors: ColorsProtocol {
    var background: UIColor { .white }
    var background1: UIColor { .init(white: 0.93, alpha: 1) }
    var background2: UIColor = UIColor(hex: "#F3EAFCFF")!
    var inactiveButton: UIColor = UIColor(hex: "#E9D5FEFF")!
    var errorColor: UIColor = UIColor(hex: "#F0260BFF")!
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
