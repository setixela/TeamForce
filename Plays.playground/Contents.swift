//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import ReactiveWorks
import UIKit

func example(_ name: String = "", action: () -> Void) {
   print("\n--- Example \(name):")
   action()
}

let nc = UINavigationController()
nc.view.frame = CGRect(x: 0, y: 0, width: 360, height: 640)
PlaygroundPage.current.liveView = nc

///////// """ STATEABLE -> PARAMETRIC """

///// MARK: - СДЕЛАТЬ АНИМАЦИЮ ПОЯВЛЕНИЯ БЛОКОВ

//   .setLeft {
//      $0
//         .set(.backColor(.blue))
//         .set(.size(.init(width: 100, height: 100)))
//   }

class VC: UIViewController {
   override func loadView() {
      view = historyModel.view
      // view.backgroundColor = .red
   }
}

// let vc = VC()
// nc.viewControllers = [vc]

struct HistoryViewEvent: InitProtocol {}

let historyModel = HistoryViewModel<ProductionAsset>()
final class HistoryViewModel<Asset: AssetProtocol>: BaseViewModel<UIStackView>,
   Communicable,
   Stateable,
   Assetable
{
   typealias State = StackState

   var eventsStore: HistoryViewEvent = .init()

   // MARK: - View Models

   private lazy var tableModel = TableViewModel()
      .set(.borderColor(.gray))
      .set(.borderWidth(1))
      .set(.cornerRadius(Design.params.cornerRadius))

   // MARK: - Frame Cells

   // MARK: - Services

   private lazy var getTransactionsUseCase = Asset.apiUseCase.getTransactions.work

   private let combo = ComboMRD()
   private let badgedModel = BadgedViewModel<ComboMRD, Design>()
      .onModeChanged(\.error) { _ in
//
      }
      .onModeChanged(\.normal) { _ in
      }
      .setMode(\.normal)

   override func start() {
      set(.alignment(.leading))
      set(.axis(.vertical))
      set(.models([
         Spacer(160),
         badgedModel,
         Spacer(64),
         combo,
         Spacer(16),
         Spacer()
      ]))
   }
   //  .set(.hidden(true))
}

// cменить дизайн
// бизнес логику изолировать

import SwiftCSSParser
struct CSSParser {
   static func parse(string: String) {}
}

let string = """
:root {
  --general-general-color-brand: #FFBF60;
  --general-general-color-black: #212121;
  --general-general-color-white: #F9FDFF;
  --general-general-color-secondary: #8A8A8E;
  --general-general-corol-grey: #9FAFFF;
  --secondary-secondary-color-brand: #FFF0D9;
  --minor-color-success-primary: #42AB44;
  --minor-color-success-secondary: #EDF8ED;
  --minor-color-error-primary: #FA1255;
  --minor-color-error-secondary: #FEEFEF;
  --minor-color-warning-primary: #FFD53F;
  --minor-color-warning-secondary: #FFF4EC;
  --minor-color-info-primary: #2E5AAC;
  --minor-color-info-secondary: #EEF2FA;
}
"""

let styleScheet = try Stylesheet.parse(from: string)
let tokens = try Stylesheet.parseTokens(from: string)

styleScheet.statements.forEach {
   switch $0 {
   case .charsetRule(let value):
      print(value)
   case .importRule(let value):
      print(value)
   case .namespaceRule(let value):
      print(value)
   case .atBlock(let value):
      print(value)
   case .ruleSet(let value):
      value.declarations.forEach {
         print($0.property)
         print($0.value)
      }
   }
}

let value = 0x00000001
print(value)
let color = UIColor(value)
print(color)

let minValue = 0xffffff // 16777215
print(minValue)

