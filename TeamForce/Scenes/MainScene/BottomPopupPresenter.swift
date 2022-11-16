//
//  BottomPopupModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.09.2022.
//

import ReactiveWorks
import UIKit

struct PopupEvent: InitProtocol {
   var present: (model: UIViewModel, onView: UIView?)?
   var presentAuto: (model: UIViewModel, onView: UIView?)?
   var hide: Void?
}

enum PopupAlign: CGFloat {
   case top = -1
   case bottom = 1
}

protocol PopupPresenterProtocol: AnyObject {
   var align: PopupAlign { get }
   var darkView: UIView? { get set }
   var presentDuration: CGFloat { get }
}

final class BottomPopupPresenter: BasePopupPresenter {
   override var align: PopupAlign { .bottom }
}

final class TopPopupPresenter: BasePopupPresenter {
   override var align: PopupAlign { .top }
}

// BASE

class BasePopupPresenter: BaseModel, PopupPresenterProtocol, Eventable {
   var align: PopupAlign { .bottom }
   var darkView: UIView?

   typealias Events = PopupEvent
   var events: [Int: LambdaProtocol?] = [:]

   let presentDuration: CGFloat = 0.3

   var viewTranslation = CGPoint(x: 0, y: 0)

   lazy var queue: Queue<UIViewModel> = .init()

   override func start() {
      on(\.present) { [weak self] model, onView in
         onView?.endEditing(true)

         guard let self = self,
               let onView = onView
         else { return }

         let view = self.prepareModel(model, onView: onView)
         switch self.align {
         case .top:
            view.addAnchors.fitToTop(onView)
         case .bottom:
            view.addAnchors.fitToViewInsetted(onView, .init(top: 40, left: 0, bottom: 0, right: 0))
         }

         self.animateViewAppear(view)
         self.queue.push(model)
      }
      .on(\.presentAuto) { [weak self] model, onView in
         onView?.endEditing(true)

         guard let self = self,
               let onView = onView
         else { return }

         let view = self.prepareModel(model, onView: onView)
         view.addAnchors
            .width(onView.widthAnchor)
            .bottom(onView.bottomAnchor)
         self.animateViewAppear(view)
         self.queue.push(model)
      }
      .on(\.hide) { [weak self] in
         self?.hideView()
      }
   }

   func prepareModel(_ model: UIViewModel, onView: UIView) -> UIView {
      self.darkView?.removeFromSuperview()

      let view = model.uiView

      let darkView = UIView(frame: onView.frame)
      darkView.backgroundColor = .darkText
      darkView.alpha = 0
      self.darkView = darkView

      onView.addSubview(darkView)
      onView.addSubview(view)

      return view
   }

   func animateViewAppear(_ view: UIView) {
      view.layoutIfNeeded()

      let viewHeight = view.intrinsicContentSize.height//.frame.height

      view.transform = CGAffineTransform(translationX: 0, y: viewHeight * align.rawValue)
      UIView.animate(withDuration: presentDuration) {
         view.transform = CGAffineTransform(translationX: 0, y: 0)
         self.darkView?.alpha = 0.75
      }

      let tapGest = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
      tapGest.cancelsTouchesInView = false

      view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
      view.addGestureRecognizer(tapGest)
   }

   @objc func didTapOnView(sender: UITapGestureRecognizer) {
      sender.view?.endEditing(true)
   }

   @objc func handleDismiss(sender: UIPanGestureRecognizer) {
      guard let view = sender.view else { return }

      switch sender.state {
      case .changed:
         viewTranslation = sender.translation(in: view)
         switch align {
         case .bottom:
            UIView.animate(withDuration: presentDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
               view.transform = CGAffineTransform(
                  translationX: 0,
                  y: self.viewTranslation.y > 0 ? self.viewTranslation.y : 0)
            })
         case .top:
            UIView.animate(withDuration: presentDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
               view.transform = CGAffineTransform(
                  translationX: 0,
                  y: self.viewTranslation.y < 0 ? self.viewTranslation.y : 0)
            })
         }

      case .ended:
         switch align {
         case .bottom:

            if viewTranslation.y < 200 {
               UIView.animate(withDuration: presentDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                  view.transform = .identity
               })
            } else {
               hideView()
            }
         case .top:
            if viewTranslation.y > 200 {
               UIView.animate(withDuration: presentDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                  view.transform = .identity
               })
            } else {
               hideView()
            }
         }
      default:
         break
      }
   }

   func hideView() {
      guard let view = queue.pop()?.uiView else {
         return
      }

      UIView.animate(withDuration: 0.23) {
         if self.queue.isEmpty {
            self.darkView?.alpha = 0
         }
         view.transform = CGAffineTransform(translationX: 0, y: view.frame.height * self.align.rawValue)
      } completion: { _ in
         if self.queue.isEmpty {
            self.darkView?.removeFromSuperview()
            self.darkView = nil
         }
         view.removeFromSuperview()
         view.transform = .identity
      }
   }
}
