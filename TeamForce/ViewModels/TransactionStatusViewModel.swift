//
//  TransactionStatusViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 02.08.2022.
//

import ReactiveWorks
import UIKit

struct StatusViewInput {
   var baseView: UIView
   var sendCoinInfo: SendCoinRequest
   var username: String
}

struct TransactionStatusViewEvents: InitProtocol {
   var presentOnScene: Event<StatusViewInput>?
   var hide: Event<Void>?
}

final class TransactionStatusViewModel<Asset: AssetProtocol>: BaseViewModel<UIStackView>,
   Communicable,
   Stateable,
   Assetable
{
   typealias State = StackState
   var eventsStore: TransactionStatusViewEvents = .init()

   private let backgroundView: UIView = {
      let backgroundView = UIView()
      backgroundView.backgroundColor = .black
      backgroundView.alpha = 0
      return backgroundView
   }()

   private lazy var image: ImageViewModel = {
      let image = ImageViewModel()
         .set(.size(.init(width: 242, height: 242)))
         .set(.image(Design.icon.make(\.girlOnSkateboard)))
         .set(.contentMode(.scaleAspectFit))
      return image

   }()

   let statusLabel = Design.label.headline5
      .set(.text(Text.title.thanksWereSend))
      .set(.numberOfLines(1))
      .set(.alignment(.center))
      .set(.padding(.init(top: 22, left: 0, bottom: 26, right: 0)))

   let amountLabel = Design.label.headline3
      .set(.numberOfLines(1))
      .set(.alignment(.center))
      .set(.padding(.init(top: 22, left: 0, bottom: 26, right: 0)))
      .set(.color(Design.color.activeButtonBack))

   let reasonLabel = Design.label.body1
      .set(.alignment(.center))
      .set(.numberOfLines(5))
      .set(.color(UIColor.lightGray))

   let recipientLabel = Design.label.body1
      .set(.alignment(.center))

   let button = Design.button.default
      .set(.title(Text.button.toTheBeginingButton))

   override func start() {
      set(Design.state.stack.default)
      set(.backColor(Design.color.background2))
      set(.cornerRadius(Design.params.cornerRadius))
      set(.alignment(.fill))
      set(.spacing(16))
//        set(.distribution(.fill))

      set(.models([
         Spacer(20),
         image,
         statusLabel,
         amountLabel,
         reasonLabel,
         recipientLabel,
         button,
         Spacer()
      ]))

      onEvent(\.presentOnScene) { [weak self] input in
         self?.setup(info: input.sendCoinInfo, username: input.username)
         self?.show(baseView: input.baseView)
      }
      .onEvent(\.hide) { [weak self] in
         self?.hide()
      }

      button.onEvent(\.didTap) {
         self.hide()
      }
   }

   private func setup(info: SendCoinRequest, username: String) {
      amountLabel.set(.text("-" + info.amount))
      reasonLabel.set(.text(info.reason))
      recipientLabel.set(.text(TextBuilder.title.recipient + username))
   }
}

extension TransactionStatusViewModel {
   private func show(baseView: UIView) {
      view.removeFromSuperview()
      let size = baseView.frame.size
      let origin = baseView.frame.origin
      view.frame.size = CGSize(width: size.width * 0.85, height: size.height * 0.85)
      view.frame.origin = CGPoint(x: -size.width, y: origin.y)

      backgroundView.frame = baseView.bounds
      baseView.addSubview(backgroundView)
      baseView.addSubview(view)
      UIView.animate(withDuration: 0.25, animations: {
         self.backgroundView.alpha = 0.6
      })

      UIView.animate(withDuration: 0.25) {
         self.view.center = baseView.center
      }
   }

   private func hide() {
      print("\nHIDE\n")

      UIView.animate(withDuration: 0.25) {
         self.view.frame.origin = CGPoint(x: -self.view.frame.size.width, y: 0)
         self.backgroundView.alpha = 0
      }
   }
}
