//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import UIKit

class MyViewController: UIViewController {
   override func loadView() {
      let view = UIView()
      view.backgroundColor = .white

      self.view = view
   }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

struct TagPercent {
   let name: String
   let percent: Int
}

struct TagsPercentData {
   let tagsPercent: [TagPercent]
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
      "Ответственность"
   ]

   static func getTagsPersents() -> TagsPercentData {
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
         let percent = Int(($1 / sum * 100).rounded(.toNearestOrAwayFromZero))
         return TagPercent(name: tag, percent: percent)
      }

      return TagsPercentData(tagsPercent: tagsPercents)
   }
}

print(RandomTagsPercentDataSource.getTagsPersents())
