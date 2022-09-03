//
//  BottomPopupModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.09.2022.
//

import ReactiveWorks
import UIKit

struct PopupEvent: InitProtocol {
   var present: (model: UIViewModel, onView: UIView)?
   var hide: Void?
}

final class BottomPopupPresenter: BaseModel, Eventable {
   typealias Events = PopupEvent

   var events: [Int: LambdaProtocol?] = [:]

   private var viewTranslation = CGPoint(x: 0, y: 0)
   private var darkView: UIView?

   private lazy var queue: Queue<UIViewModel> = .init()

   override func start() {
      on(\.present) { [weak self] model, onView in
         guard let self = self else { return }

         self.darkView?.removeFromSuperview()

         let offset: CGFloat = 40
         let view = model.uiView

         let height = onView.frame.height

         view.translatesAutoresizingMaskIntoConstraints = true

         let darkView = UIView(frame: onView.frame)
         darkView.backgroundColor = .darkText
         darkView.alpha = 0
         onView.addSubview(darkView)
         onView.addSubview(view)

         view.frame.size = .init(width: onView.frame.width, height: height - offset)
         view.frame.origin = .init(x: 0, y: height)

         UIView.animate(withDuration: 0.5) {
            view.frame.origin = .init(x: 0, y: offset)
            darkView.alpha = 0.75
         } completion: { _ in
            view.addAnchors.fitToViewInsetted(onView, .init(top: offset, left: 0, bottom: 0, right: 0))
            view.layoutIfNeeded()
         }

         view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handleDismiss)))
         view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapOnView)))

         self.darkView = darkView
         self.queue.push(model)
      }
      .on(\.hide) { [weak self] in
         self?.hideView()
      }
   }

   @objc func handleDismiss(sender: UIPanGestureRecognizer) {
      guard let view = sender.view else { return }

      switch sender.state {
      case .changed:
         viewTranslation = sender.translation(in: view)
         UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            view.transform = CGAffineTransform(translationX: 0,
                                               y: self.viewTranslation.y > 0 ? self.viewTranslation.y : 0)
         })
      case .ended:
         if viewTranslation.y < 200 {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
               view.transform = .identity
            })
         } else {
            hideView()
         }
      default:
         break
      }
   }

   @objc func didTapOnView(sender: UITapGestureRecognizer) {
      sender.view?.endEditing(true)
   }

   private func hideView() {
      guard let view = queue.pop()?.uiView else {
         return
      }

      UIView.animate(withDuration: 0.23) {
         if self.queue.isEmpty {
            self.darkView?.alpha = 0
         }
         view.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
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
