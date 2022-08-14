//
//  Colors.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.07.2022.
//

import ReactiveWorks
import UIKit

protocol ColorTokenProtocol {}

enum ColorToken: String, ColorTokenProtocol {
    //
    case brand = "--general-general-color-brand"
    case brand2 = "--secondary-secondary-color-brand"
    //
    case black = "--general-general-color-black"
    case grey = "--general-general-corol-grey"
    case white = "--general-general-color-white"
    case secondary = "--general-general-color-secondary"
    //
    case info = "--minor-color-info-primary"
    case info2 = "--minor-color-info-secondary"
    //
    case success = "--minor-color-success-primary"
    case success2 = "--minor-color-success-secondary"
    //
    case warning = "--minor-color-warning-primary"
    case warning2 = "--minor-color-warning-secondary"
    //
    case error = "--minor-color-error-primary"
    case error2 = "--minor-color-error-secondary"
}

// Протокол Фабрики цветов ( Разнести потом палитру и детали и обьекты)
protocol ColorsProtocol: InitProtocol {
    associatedtype Token: ColorTokenProtocol

    // Common colors
    var transparent: UIColor { get }

    // Text colors
    var text: UIColor { get }
    var text2: UIColor { get }

    var textInvert: UIColor { get }
    var text2Invert: UIColor { get }

    // Backs
    var background: UIColor { get }
    var background2: UIColor { get }

    // Buttons
    var activeButtonBack: UIColor { get }
    var inactiveButtonBack: UIColor { get }
    var transparentButtonBack: UIColor { get }

    // Textfield
    var textFieldBack: UIColor { get }

    // Boundaries
    var boundary: UIColor { get }
    var boundaryError: UIColor { get }
}

// MARK: - Colors implement

// Палитра
struct ColorBuilder: ColorsProtocol {
    typealias Token = ColorToken

    var transparent: UIColor { .clear }

    var text: UIColor { Token.black.color }
    var text2: UIColor { Token.secondary.color }

    var textInvert: UIColor { Token.white.color }
    var text2Invert: UIColor { Token.grey.color }

    var background: UIColor { Token.white.color }
    var background2: UIColor { Token.brand2.color }

    // button colors
    var activeButtonBack: UIColor { Token.brand.color }
    var inactiveButtonBack: UIColor { Token.brand2.color }
    var transparentButtonBack: UIColor { transparent }

    // textfield colors
    var textFieldBack: UIColor { Token.white.color }

    // boundaries
    var boundary: UIColor { Token.grey.color }
    var boundaryError: UIColor { Token.error.color }
}

// MARK: - Private helpers

import SwiftCSSParser

private extension ColorToken {
    var color: UIColor {
        guard let color = Self.colors[self] else { return UIColor() }

        return color
    }

    static let cssColorString: String = {
        if let filepath = Bundle.main.path(forResource: "CssColors", ofType: "css") {
            do {
                let contents = try String(contentsOfFile: filepath)
                return contents
            } catch {
                fatalError()
            }
        } else {
            fatalError()
        }
    }()

    static let colors: [ColorToken: UIColor] = {
        let styleScheet = try? Stylesheet.parse(from: cssColorString)

        var colors = [ColorToken: UIColor]()

        styleScheet?.statements.forEach {
            switch $0 {
            case .ruleSet(let value):
                value.declarations.forEach {
                    let property = $0.property
                    let value = $0.value

                    guard let key = ColorToken(rawValue: property) else { return }

                    let color = UIColor(value)
                    colors[key] = color
                }
            default:
                break
            }
        }

        return colors
    }()
}

private extension UIColor {
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xff0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00ff00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000ff) / 255.0,
            alpha: alpha)
    }
}
