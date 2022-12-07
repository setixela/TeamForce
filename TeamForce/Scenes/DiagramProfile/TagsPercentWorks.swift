//
//  TagsPercentWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 07.12.2022.
//

import Foundation
import ReactiveWorks

class TagsPercentsStorage: InitProtocol {
   required init() {}

   var tagsPercents: [TagPercent] = []
}

protocol DiagramProfileWorksProtocol: TempStorage, Assetable where
   Asset: AssetProtocol,
   Temp: TagsPercentsStorage
{
   var loadTagPercents: Work<Void, Void> { get }
   //
   var getTagsPercentsData: Work<Void, [TagPercent]> { get }
}

extension DiagramProfileWorksProtocol {
   var loadTagPercents: Work<Void, Void> { .init { work in
      // TODO: - Random fish
      let percentTags = RandomTagsPercentDataSource.getTagsPersents()
      Self.store.tagsPercents = percentTags

      work.success()
   } }

   var getTagsPercentsData: Work<Void, [TagPercent]> { .init { work in
      let tagsPercents = Self.store.tagsPercents
      guard !tagsPercents.isEmpty else {
         work.fail()
         return
      }

      work.success(tagsPercents)
   } }
}

import UIKit

struct TagPercent {
   let name: String
   let percent: CGFloat
}

// TODO: - Demo fish
enum RandomTagsPercentDataSource {
   private static let tags = [
      "Клиентоориентированность",
      "Этичность",
      "Инновационность",
      "Доверие",
      "Целеустремленность",
      "Целенаправленность",
      "Высокое качество",
      "Командная работа",
      "Ответственность",
   ]

   static func getTagsPersents() -> [TagPercent] {
      let count = Int.random(in: 0..<tags.count)

      var array = tags
      var selectedElements: [String] = []

      for _ in 0..<count {
         if let randomElement = array.randomElement() {
            selectedElements.append(randomElement)
            array.removeAll(where: { $0 == randomElement })
         }
      }

      let selectedCounts = selectedElements.count

      let randomNumbers = (0..<selectedCounts).map { _ in Double(arc4random_uniform(101)) }
      let sum = randomNumbers.reduce(0, +)
      let tagsPercents = randomNumbers.enumerated().map {
         let tag = selectedElements[$0]
         let percent = $1 / sum // Int(($1 * 100).rounded(.toNearestOrAwayFromZero))
         return TagPercent(name: tag, percent: percent)
      }

      return tagsPercents
   }
}

extension UIColor {
   var hue: CGFloat {
      var hue: CGFloat = 0.0
      var saturation: CGFloat = 0.0
      var brightness: CGFloat = 0.0
      var alpha: CGFloat = 0.0

      getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
      return hue
   }

   func colorsCircle(_ count: Int, saturate: CGFloat, bright: CGFloat) -> [UIColor] {
      let step = 1.0 / CGFloat(count)
      var hue = hue
      let colors = (0..<count).map { _ in
         let color = UIColor(hue: hue, saturation: saturate, brightness: bright, alpha: 1)
         hue += step
         return color
      }

      return colors
   }
}
