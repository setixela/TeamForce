//
//  HistoryViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 04.08.2022.
//

import ReactiveWorks
import UIKit

struct HistoryViewEvent: InitProtocol {}

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
      .set(.cornerRadius(Design.Parameters.cornerRadius))

   // MARK: - Frame Cells

   // MARK: - Services

   private lazy var getTransactionsUseCase = Asset.apiUseCase.getTransactions.work()

   override func start() {
      set(.models([tableModel]))

      let models = (0 ..< 100).map { index in

         LogoTitleSubtitleModel(isAutoreleaseView: true)
            .set(.image(Design.icon.make(\.checkCircle)))
            .set(.padding(.outline(10)))
            .set(.size(.init(width: 64, height: 64)))
            .setRight {
               $0
                  .set(.text(String(index)))
                  .setDown {
                     $0.set(.text("Helllo"))
                  }
            }
      }

      tableModel
         .set(.backColor(.gray))
         .set(.models(models))

      print("transactions started")
      getTransactionsUseCase
         .doAsync()
         .onSuccess { transactions in
            print(transactions)
         }
         .onFail {
            print("transactions not loaded")
         }
   }
}

extension UIEdgeInsets {
   static func outline(_ width: CGFloat) -> UIEdgeInsets {
      .init(top: width, left: width, bottom: width, right: width)
   }
}
