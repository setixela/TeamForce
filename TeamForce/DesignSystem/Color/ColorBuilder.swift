//
//  Colors.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.07.2022.
//

import ReactiveWorks
import UIKit

protocol ColorTokenProtocol {}

// imported from Figma via "Colors to Code" Figma's plugin
enum ColorToken: String, ColorTokenProtocol {
    //
    case brand = "--general-brand"
    case brandSecondary = "--general-brand-secondary"
    case contrast = "--general-contrast"
    case contrastSecondary = "--general-contrast-secondary"
    case midpoint = "--general-grey"
    case midpointSecondary = "--general-grey-secondary"
    case inverse = "--general-inverse"
    case inverseSecondary = "--general-inverse-secondary"
    case success = "--minor-success"
    case successSecondary = "--minor-success-secondary"
    case error = "--minor-error"
    case errorSecondary = "--minor-error-secondary"
    case warning = "--minor-warning"
    case warningSecondary = "--minor-warning-secondary"
    case info = "--minor-info"
    case infoSecondary = "--minor-info-secondary"
}

// Протокол Фабрики цветов
protocol ColorsProtocol: InitProtocol {
    associatedtype Token: ColorTokenProtocol

    // Common colors
    var transparent: UIColor { get }

    // Text colors
    var text: UIColor { get }
    var textSecondary: UIColor { get }
    var textError: UIColor { get }
    var textInvert: UIColor { get }
    var textSecondaryInvert: UIColor { get }
    var textThird: UIColor { get }
    var textThirdInvert: UIColor { get }

    // Backs
    var background: UIColor { get }
    var backgroundSecondary: UIColor { get }
    var backgroundBrand: UIColor { get }

    // Buttons
    var activeButtonBack: UIColor { get }
    var inactiveButtonBack: UIColor { get }
    var transparentButtonBack: UIColor { get }

    // Textfield
    var textFieldBack: UIColor { get }

    // Boundaries
    var boundary: UIColor { get }
    var boundaryError: UIColor { get }

    // Images
    var iconContrast: UIColor { get }
    var iconInvert: UIColor { get }
}

// MARK: - Colors implement

// Палитра
struct ColorBuilder: ColorsProtocol {

    typealias Token = ColorToken

    var transparent: UIColor { .clear }

    var text: UIColor { Token.contrast.color }
    var textSecondary: UIColor { Token.contrast.color }
    var textSecondaryInvert: UIColor { Token.inverseSecondary.color }
    var textThird: UIColor { Token.contrast.color }
    var textThirdInvert: UIColor { Token.inverseSecondary.color }
    var textInvert: UIColor { Token.inverse.color }
    var textError: UIColor { Token.error.color }

    var background: UIColor { Token.inverse.color }
    var backgroundSecondary: UIColor { Token.inverseSecondary.color }
    var backgroundBrand: UIColor { Token.brand.color }

    // button colors
    var activeButtonBack: UIColor { Token.brand.color }
    var inactiveButtonBack: UIColor { Token.brandSecondary.color }
    var transparentButtonBack: UIColor { transparent }

    // textfield colors
    var textFieldBack: UIColor { Token.inverse.color }

    // boundaries
    var boundary: UIColor { Token.midpoint.color }
    var boundaryError: UIColor { Token.error.color }

    // icons
    var iconContrast: UIColor { Token.contrast.color }
    var iconInvert: UIColor { Token.inverse.color }
}

// MARK: - Private helpers

import SwiftCSSParser

private extension ColorToken {
    var color: UIColor {
        guard let color = Self.colors[self] else { fatalError() }

        return color
    }

    static let cssColorString: String = {
        guard
            let filepath = Bundle.main.path(forResource: "CssColors", ofType: "css"),
            let contents = try? String(contentsOfFile: filepath)
        else { fatalError() }

        return contents
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
