//
//  TableItemsModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 17.08.2022.
//

import UIKit
import ReactiveWorks

struct TableItemsSection {
   let title: String
   var items: [Any]
}

enum TableItemsState {
   case items([Any])
   case itemSections([TableItemsSection])
   case presenters([PresenterProtocol])
}

struct TableItemsEvents: InitProtocol {
   var didSelectRow: Event<IndexPath>?
   var reloadData: Event<Void>?
}

final class TableItemsModel: BaseViewModel<UITableView> {
   var eventsStore: TableItemsEvents = .init()

   private var isMultiSection: Bool = false

   private var presenters: [String: PresenterProtocol] = [:]

   private var items: [Any] = []
   private var itemSections: [TableItemsSection] = []

   override func start() {
      view.delegate = self
      view.dataSource = self
   }
}

extension TableItemsModel: Stateable2 {
   typealias State = ViewState

   func applyState(_ state: TableItemsState) {
      switch state {
      case .items(let items):
         self.items = items
         view.reloadData()
      case .itemSections(let sections):
         itemSections = sections
         isMultiSection = true
         view.reloadData()
         //
      case .presenters(let presenters):
         self.presenters.removeAll()
         presenters.forEach {
            let key =  $0.cellType
            self.presenters[key] = $0
         }
      }
   }
}

extension TableItemsModel: Communicable {}

extension TableItemsModel: UITableViewDelegate {
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      sendEvent(\.didSelectRow, payload: indexPath)
      tableView.deselectRow(at: indexPath, animated: true)
   }
}

extension TableItemsModel: UITableViewDataSource {
   func numberOfSections(in tableView: UITableView) -> Int {
      isMultiSection ? itemSections.count : 1
   }

   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      isMultiSection ? itemSections[section].title : nil
   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      isMultiSection ? itemSections[section].items.count : items.count
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let item = isMultiSection ? itemSections[indexPath.section].items[indexPath.row] : items[indexPath.row]

      let cellName = String(describing: type(of: item))
      log(self, cellName)

      view.register(UITableViewCell.self, forCellReuseIdentifier: cellName)

      let cell = tableView.dequeueReusableCell(withIdentifier: cellName) ?? UITableViewCell()

      let presenter = presenters[cellName]
      let modelView = presenter?.viewModel(for: item).uiView ?? UIView()

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
