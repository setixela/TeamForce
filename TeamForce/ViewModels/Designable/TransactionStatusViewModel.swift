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
   var didHide: Event<Void>?
}

final class TransactionStatusViewModel<Design: DSP>: BaseViewModel<StackViewExtended>,
   Communicable,
   Stateable2,
   Designable
{
   typealias State = StackState
   typealias State2 = ViewState
   var events: TransactionStatusViewEvents = .init()

   private let backgroundView: UIView = {
      let backgroundView = UIView()
      backgroundView.backgroundColor = .black
      backgroundView.alpha = 0
      return backgroundView
   }()

   private lazy var image: ImageViewModel = {
      let image = ImageViewModel()
         .set(.size(.init(width: 242, height: 242)))
         .set(.image(Design.icon.girlOnSkateboard))
         .set(.contentMode(.scaleAspectFit))
      return image

   }()

   let statusLabel = Design.label.headline5
      .set(.text(Design.Text.title.thanksWereSend))
      .set(.numberOfLines(1))
      .set(.alignment(.center))
      .set(.padding(.init(top: 22, left: 0, bottom: 26, right: 0)))

   let amountLabel = Design.label.headline3
      .set(.numberOfLines(1))
      .set(.alignment(.center))
      .set(.padding(.init(top: 22, left: 0, bottom: 26, right: 0)))
      .set(.textColor(Design.color.activeButtonBack))

   let reasonLabel = Design.label.body1
      .set(.alignment(.center))
      .set(.numberOfLines(5))
      .set(.textColor(UIColor.lightGray))

   let recipientLabel = Design.label.body1
      .set(.alignment(.center))

   let button = Design.button.default
      .set(.title(Design.Text.button.toTheBeginingButton))

   override func start() {
      set(Design.state.stack.default)
      set(.backColor(Design.color.backgroundSecondary))
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


      baseView.addSubview(backgroundView)
      baseView.addSubview(view)
      view.addAnchors.fitToView(backgroundView)
      view.addAnchors.fitToView(baseView)

      UIView.animate(withDuration: 0.25, animations: {
         self.backgroundView.alpha = 0.6
      })
   }

   private func hide() {
      print("\nHIDE\n")

      UIView.animate(withDuration: 0.25) {
      //   self.view.frame.origin = CGPoint(x: -self.view.frame.size.width, y: 0)
         self.backgroundView.alpha = 0
      } completion: {_ in 
         self.sendEvent(\.didHide)
      }
   }
}
