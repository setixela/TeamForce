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

   case negative = "--general-negative"
   case negativeSecondary = "--minor-negative-secondary"

   case midpoint = "--general-midpoint"
   //   case midpointSecondary = "" //?

   case success = "--minor-success"
   case successSecondary = "--minor-success-secondary"

   case error = "--minor-error"
   case errorSecondary = "--minor-error-secondary"

   case warning = "--minor-warning"
   case warningSecondary = "--minor-warning-secondary"

   case info = "--minor-info"
   case infoSecondary = "--minor-info-secondary"

   case extra1 = "--extra1"
   case extra2 = "--extra2"
}

// Протокол Фабрики цветов
protocol ColorsProtocol: InitProtocol {
   associatedtype Token: ColorTokenProtocol

   // Common colors
   var transparent: UIColor { get }

   // Text colors
   var text: UIColor { get }
   var textSecondary: UIColor { get }
   var textSuccess: UIColor { get }
   var textInfo: UIColor { get }
   var textError: UIColor { get }
   var textInvert: UIColor { get }
   var textBrand: UIColor { get }
   var textSecondaryInvert: UIColor { get }
   var textThird: UIColor { get }
   var textThirdInvert: UIColor { get }
   var textContrastSecondary: UIColor { get }

   // Backs
   var background: UIColor { get }
   var backgroundSecondary: UIColor { get }
   var backgroundBrand: UIColor { get }
   var backgroundBrandSecondary: UIColor { get }
   var backgroundInfo: UIColor { get }
   var backgroundInfoSecondary: UIColor { get }
   var backgroundSuccess: UIColor { get }
   var infoSecondary: UIColor { get }

   // Buttons
   var activeButtonBack: UIColor { get }
   var inactiveButtonBack: UIColor { get }
   var transparentButtonBack: UIColor { get }

   // Textfield
   var textFieldBack: UIColor { get }
   var textFieldPlaceholder: UIColor { get }

   // Boundaries
   var boundary: UIColor { get }
   var boundaryError: UIColor { get }

   // Images
   var iconContrast: UIColor { get }
   var iconSecondary: UIColor { get }
   var iconMidpoint: UIColor { get }
   var iconMidpointSecondary: UIColor { get }
   var iconInvert: UIColor { get }
   var iconBrand: UIColor { get }
   var iconBrandSecondary: UIColor { get }
   var iconWarning: UIColor { get }
   var iconError: UIColor { get }

   // Frame cell color
   var frameCellBackground: UIColor { get }
   var frameCellBackgroundSecondary: UIColor { get }

   // Tables
   var cellSeparatorColor: UIColor { get }

   // success error
   var errorSecondary: UIColor { get }
   var success: UIColor { get }
   var successSecondary: UIColor { get }
}

// MARK: - Colors implement

// Палитра
struct ColorBuilder: ColorsProtocol {
   typealias Token = ColorToken

   var transparent: UIColor { .clear }

   var text: UIColor { Token.contrast.color }
   var textSecondary: UIColor { Token.contrastSecondary.color }
   var textSecondaryInvert: UIColor { Token.negative.color }
   var textSuccess: UIColor { Token.success.color }
   var textInfo: UIColor { Token.info.color }
   var textThird: UIColor { Token.contrast.color }
   var textThirdInvert: UIColor { Token.negative.color }
   var textInvert: UIColor { Token.negative.color }
   var textError: UIColor { Token.error.color }
   var textContrastSecondary: UIColor { Token.contrastSecondary.color }
   var textBrand: UIColor { Token.brand.color }

   var background: UIColor { Token.negative.color }
   var backgroundSecondary: UIColor { Token.negative.color }
   var backgroundBrand: UIColor { Token.brand.color }
   var backgroundBrandSecondary: UIColor { Token.brandSecondary.color }
   var infoSecondary: UIColor { Token.infoSecondary.color }

   var backgroundInfo: UIColor { Token.info.color }
   var backgroundInfoSecondary: UIColor { Token.infoSecondary.color }
   var backgroundSuccess: UIColor { Token.success.color }

   // button colors
   var activeButtonBack: UIColor { Token.brand.color }
   var inactiveButtonBack: UIColor { Token.brandSecondary.color }
   var transparentButtonBack: UIColor { transparent }

   // textfield colors
   var textFieldBack: UIColor { Token.negative.color }
   var textFieldPlaceholder: UIColor { Token.midpoint.color }

   // boundaries
   var boundary: UIColor { Token.midpoint.color }
   var boundaryError: UIColor { Token.error.color }

   // icons
   var iconContrast: UIColor { Token.contrast.color }
   var iconSecondary: UIColor { Token.contrastSecondary.color }
   var iconMidpoint: UIColor { Token.midpoint.color }
   var iconMidpointSecondary: UIColor { Token.midpoint.color }
   var iconInvert: UIColor { Token.negative.color }
   var iconBrand: UIColor { Token.brand.color }
   var iconBrandSecondary: UIColor { Token.brandSecondary.color }
   var iconWarning: UIColor { Token.warning.color }
   var iconError: UIColor { Token.error.color }

   // Frame cell color
   var frameCellBackground: UIColor { Token.extra1.color }
   var frameCellBackgroundSecondary: UIColor { Token.extra2.color }

   // Tables
   var cellSeparatorColor: UIColor { Token.midpoint.color }

   // success error
   var errorSecondary: UIColor { Token.errorSecondary.color }
   var success: UIColor { Token.success.color }
   var successSecondary: UIColor { Token.successSecondary.color }
}

// MARK: - Private helpers

import SwiftCSSParser

enum OrganizationColorScheme: Int {
   case teamForce = 1
   case ruDemo = 4
   case ruDemo2 = 69

   func colorScheme() -> String {
      switch self {
      case .teamForce:
         return "CssColors"
      case .ruDemo:
         return "CssColors2"
      case .ruDemo2:
         return "CssColors2"
      }
   }
}

extension ColorToken {
   static func recolor() {
      let colorSchemeName = UserDefaults.standard.loadString(forKey: .colorSchemeKey)
         ?? OrganizationColorScheme.teamForce.colorScheme()

      let str = loadColorsCss(colorSchemeName)
      let colors = parseCssColors(str)
      currentColors = colors
   }

   static func loadColorsFor(_ org: OrganizationColorScheme) -> [ColorToken: UIColor] {
      let str = loadColorsCss(org.colorScheme())
      let colors = parseCssColors(str)
      return colors
   }

   static func brandColorForOrganization(_ org: OrganizationColorScheme) -> UIColor {
      let colors = loadColorsFor(org)
      return colors[.brand] ?? .black
   }
}

private extension ColorToken {
   var color: UIColor {
      if Self.currentColors == nil {
         Self.recolor()
      }

      guard let color = Self.currentColors?[self] else { fatalError() }

      return color
   }

   private static var currentColors: [ColorToken: UIColor]?

   private static func parseCssColors(_ cssString: String) -> [ColorToken: UIColor] {
      let styleScheet = try? Stylesheet.parse(from: cssString)

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
   }

   private static func loadColorsCss(_ name: String) -> String {
      guard
         let filepath = Bundle.main.path(forResource: name, ofType: "css"),
         let contents = try? String(contentsOfFile: filepath)
      else { fatalError() }

      return contents
   }
}

extension UIColor {
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
