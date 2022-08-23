//
//  StackItemsModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 23.08.2022.
//

import ReactiveWorks
import UIKit

enum StackItemsState {
   case items([Any])
   case presenters([PresenterProtocol])
   case activateSelector

   case removeAllExceptIndex(Int)
}

struct StackItemsEvents: InitProtocol {
   var didSelectRow: Event<Int>?
}

final class StackItemsModel: StackModel, Presenting, Communicable, Stateable3 {
   var presenters: [String: PresenterProtocol] = [:]
   var events = StackItemsEvents()

   private var isSelectEnabled = false

   var items: [Any] = []
}

extension StackItemsModel {
   func applyState(_ state: StackItemsState) {
      switch state {
      case .items(let items):
         self.items = items
         set_arrangedModels(items.enumerated().map {
            let model = makeModelForData($0.1)
            if isSelectEnabled {
               let rec = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
               rec.name = String($0.0)
               model.uiView.addGestureRecognizer(rec)
            }
            return model
         })
      case .presenters(let presenters):
         self.presenters.removeAll()
         presenters.forEach {
            let key = $0.cellType
            self.presenters[key] = $0
         }
      case .activateSelector:
         isSelectEnabled = true
      case .removeAllExceptIndex(let index):
         view.arrangedSubviews.enumerated().forEach {
            guard $0.offset != index else { return }
            $0.element.removeFromSuperview()
         }

         items = [items[index]]
      }
   }

   private func makeModelForData(_ item: Any) -> UIViewModel {
      let cellName = String(describing: type(of: item))

      guard let presenter = presenters[cellName] else { return ViewModel() }

      let model = presenter.viewModel(for: item)
      return model
   }

   @objc func didTap(_ sender: UIGestureRecognizer) {
      sendEvent(\.didSelectRow, Int(sender.name ?? "0") ?? 0)
   }
}

protocol Presenting {
   var presenters: [String: PresenterProtocol] { get set }
}
