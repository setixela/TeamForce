//
//  TableViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.07.2022.
//

import ReactiveWorks
import UIKit

enum TableViewState {
   case models([UIViewModel])
   case sections([TransactionSection])
}

struct TableViewEvents: InitProtocol {
   var didSelectRow: Event<Int>?
   var reloadData: Event<Void>?
}

final class TableViewModel: BaseViewModel<UITableView> {
   var eventsStore: TableViewEvents = .init()

   private var models: [UIViewModel] = []
   private var sections: [TransactionSection] = []
   private var isMultiSection: Bool = false

   override func start() {
      view.delegate = self
      view.dataSource = self
      view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
   }
}

extension TableViewModel: Stateable2 {
   typealias State = ViewState

   func applyState(_ state: TableViewState) {
      switch state {
      case .models(let array):
         isMultiSection = false
         models = array
         view.reloadData()
      case .sections(let array):
         isMultiSection = true
         sections = array
         view.reloadData()
      }
   }
}

extension TableViewModel: Communicable {}

extension TableViewModel: UITableViewDelegate {
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      sendEvent(\.didSelectRow, payload: indexPath.row)
      tableView.deselectRow(at: indexPath, animated: true)
   }
}

extension TableViewModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        isMultiSection ? sections.count : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        isMultiSection ? self.sections[section].date : nil
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       isMultiSection ? sections[section].transactions.count : models.count
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let model = isMultiSection ? sections[indexPath.section].transactions[indexPath.row] : models[indexPath.row]
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
      let modelView = model.uiView
      cell.contentView.subviews.forEach { $0.removeFromSuperview() }
      cell.contentView.addSubview(modelView)
      modelView.addAnchors.fitToView(cell.contentView)

      return cell
   }

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      UITableView.automaticDimension
   }

   func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
      UITableView.automaticDimension
   }
}
