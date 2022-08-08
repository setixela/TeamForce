//
//  TransactionStatusViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 02.08.2022.
//

import ReactiveWorks
import UIKit

struct TransactionStatusViewEvents: InitProtocol {
   var presentOnScene: Event<UIView>?
   var hide: Event<Void>?
}

final class TransactionStatusViewModel<Asset: AssetProtocol>: BaseViewModel<UIStackView>,
   Communicable,
   Stateable,
   Assetable
{
   typealias State = StackState
   var eventsStore: TransactionStatusViewEvents = .init()

   var isPresented = false
   let statusLabel = Design.label.headline4
      .set(.text(Text.title.make(\.thanksWereSend)))
      .set(.numberOfLines(1))
      .set(.alignment(.left))
      .set(.padding(.init(top: 22, left: 0, bottom: 26, right: 0)))

   let amountLabel = Design.label.headline4
      .set(.text("-1304"))
      .set(.numberOfLines(1))
      .set(.alignment(.left))
      .set(.padding(.init(top: 22, left: 0, bottom: 26, right: 0)))

   let reasonLabel = Design.label.body1
      .set(.text("good job buddy"))
      .set(.alignment(.center))

   let button = Design.button.default
      .set(.title("В начало"))

   override func start() {
      set(Design.State.mainView.default)
      set(.backColor(Design.color.background2))

      set(.models([
         statusLabel,
         Spacer(size: 16),
         amountLabel,
         Spacer(size: 16),
         reasonLabel,
         Spacer(size: 16),
         button,
         Spacer()
      ]))

      onEvent(\.presentOnScene) { [weak self] baseView in
         self?.show(baseView: baseView)
      }
      .onEvent(\.hide) { [weak self] in
         self?.hide()
      }
   }
}

extension TransactionStatusViewModel {
   private func show(baseView: UIView) {
      view.removeFromSuperview()

      let size = baseView.frame.size
      let origin = baseView.frame.origin
      view.frame.size = CGSize(width: size.width * 0.85, height: size.height * 0.85)
      view.frame.origin = CGPoint(x: -size.width, y: origin.y)
      baseView.addSubview(view)
      isPresented = true
      UIView.animate(withDuration: 0.25) {
         self.view.center = baseView.center
      }
   }

   private func hide() {
      print("\nHIDE\n")

      UIView.animate(withDuration: 0.25) {
         self.view.frame.origin = CGPoint(x: -self.view.frame.size.width, y: 0)
      }
   }
}
