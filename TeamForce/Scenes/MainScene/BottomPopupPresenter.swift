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

final class BottomPopupPresenter: BaseModel, Eventable {
   typealias Events = PopupEvent

   var events: [Int: LambdaProtocol?] = [:]

   private var viewTranslation = CGPoint(x: 0, y: 0)
   private var darkView: UIView?

   private var presentDuration = 0.3

   private lazy var queue: Queue<UIViewModel> = .init()

   override func start() {
      on(\.present) { [weak self] model, onView in
         onView?.endEditing(true)

         guard let self = self,
               let onView = onView
         else { return }

         let view = self.prepareModel(model, onView: onView)
         view.addAnchors.fitToViewInsetted(onView, .init(top: 40, left: 0, bottom: 0, right: 0))
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

   private func prepareModel(_ model: UIViewModel, onView: UIView) -> UIView {
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

   private func animateViewAppear(_ view: UIView) {
      view.layoutIfNeeded()

      let viewHeight = view.frame.height

      view.transform = CGAffineTransform(translationX: 0, y: viewHeight)
      UIView.animate(withDuration: presentDuration) {
         view.transform = CGAffineTransform(translationX: 0, y: 0)
         self.darkView?.alpha = 0.75
      }

      let tapGest = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
      tapGest.cancelsTouchesInView = false

      view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
      view.addGestureRecognizer(tapGest)
   }

   @objc private func handleDismiss(sender: UIPanGestureRecognizer) {
      guard let view = sender.view else { return }

      switch sender.state {
      case .changed:
         viewTranslation = sender.translation(in: view)
         UIView.animate(withDuration: presentDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            view.transform = CGAffineTransform(
               translationX: 0,
               y: self.viewTranslation.y > 0 ? self.viewTranslation.y : 0)
         })
      case .ended:
         if viewTranslation.y < 200 {
            UIView.animate(withDuration: presentDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
               view.transform = .identity
            })
         } else {
            hideView()
         }
      default:
         break
      }
   }

   @objc private func didTapOnView(sender: UITapGestureRecognizer) {
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
