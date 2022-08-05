//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import PromiseKit
import RealmSwift
import SwiftUI
@testable import TeamForce
import UIKit

func example(_ name: String = "", action: () -> Void) {
   print("\n--- Example \(name):")
   action()
}

let nc = UINavigationController()
nc.view.frame = CGRect(x: 0, y: 0, width: 360, height: 640)
PlaygroundPage.current.liveView = nc

///////// """ STATEABLE -> PARAMETRIC """

let work1 = Work<Int, Int>(input: 0)

class VC: UIViewController {
   override func loadView() {
      var messageTextView = UITextView()

      view = messageTextView

      messageTextView.isEditable = false
//      messageTextView.isScrollEnabled = false
//      messageTextView.backgroundColor = .clear
      messageTextView.dataDetectorTypes = .all
      messageTextView.textContainerInset = .zero
      messageTextView.contentInset = .zero
      messageTextView.textContainer.lineFragmentPadding = 0
      messageTextView.translatesAutoresizingMaskIntoConstraints = false

      let attr = NSAttributedString(string: "AJKKJSH klsajlkjdkl")

      messageTextView.attributedText = getAttributedText(at: """
            AJKKJSH\n klsajlkjdkl
      """)
//     <object height=20 width=75 type='text/plain' \n border=0 \n data="text text"></object>
   }
}

nc.viewControllers = [VC()]

// MARK: - Todo

// public protocol TargetViewProtocol: UIView {
//    associatedtype TargetView: UIView
//
//    var targetView: TargetView { get }
// }
//
// final class TargetViewModel<TVM: ViewModelProtocol>: BaseViewModel<TVM.View> {
//    lazy var targetModel = TVM()
//
//    override func start() {}
// }
//
// final class TargetView<View: UIView>: UIView, TargetViewProtocol {
//    lazy var targetView: View = {
//        let view = View()
//        self.addSubview(view)
//        return view
//    }()
//
//    typealias TargetView = View
// }

func getAttributedText(at text: String) -> NSMutableAttributedString {
   let style = NSMutableParagraphStyle()
   style.lineBreakMode = .byWordWrapping
   style.lineSpacing = 2
   let font = UIFont.systemFont(ofSize: 17)
   let attributedString = NSMutableAttributedString(attributedString: text.htmlToAttributedString ?? NSAttributedString())
   attributedString.setStyle(font: font, fontSize: 17.0, style: style, color: UIColor.black)
   let textAttachment = NSTextAttachment()
   let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
   detector?.enumerateMatches(
      in: text,
      options: [.withoutAnchoringBounds, .reportProgress],
      range: NSRange(location: 0, length: text.count),
      using: { res, _, _ in
         if res?.resultType == .link {}
      })
   return attributedString
}

extension String {

   var htmlWithBreakLineToAttributedString: NSAttributedString? {
      replacingOccurrences(of: "\n", with: "<br>")
         .htmlToAttributedString
   }

   var htmlToAttributedString: NSAttributedString? {
      let replaced = replacingOccurrences(of: "\n", with: "<br>")
      guard let data = replaced.data(using: .utf8) else { return NSAttributedString() }

      let style = NSMutableParagraphStyle()
      style.lineBreakStrategy = .standard
      style.lineBreakMode = .byTruncatingHead
      do {
         return try NSAttributedString(data: data, options:
            [
               .documentType: NSAttributedString.DocumentType.html,
               .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil)
      } catch {
         return NSAttributedString()
      }
   }

   var htmlToString: String {
      return self.htmlToAttributedString?.string ?? ""
   }
}

extension NSMutableAttributedString {
   func setStyle(font: UIFont, fontSize: CGFloat, style: NSMutableParagraphStyle, color: UIColor) {
      var range = NSRange()
      while NSMaxRange(range) < length {
         attributes(at: NSMaxRange(range), effectiveRange: &range)
         self.enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { value, range, _ in
            if let f = value as? UIFont {
               let ufd = f.fontDescriptor.withFamily(font.familyName).withSymbolicTraits(f.fontDescriptor.symbolicTraits) ?? UIFontDescriptor() // swiftlint:disable:this line_length
               let newFont = UIFont(descriptor: ufd, size: fontSize)
               removeAttribute(NSAttributedString.Key.font, range: range)
               addAttribute(NSAttributedString.Key.font, value: newFont, range: range)
            }
         }
         addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
         addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
      }
   }
}
