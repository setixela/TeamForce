//
//  TableViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.07.2022.
//

import ReactiveWorks
import UIKit

struct TableSection {
   let title: String
   let models: [UIViewModel]
}

struct TableViewEvents: InitProtocol {
   var cellForRow: Event<(UIViewModel) -> Void>?
   var didSelectRow: Event<IndexPath>?
   var reloadData: Event<Void>?
}

final class SimpleTableVM: BaseViewModel<TableViewExtended> {
   var events: TableViewEvents = .init()

   private var cellName = "cellName"

   private var models: [UIViewModel] = []
   private var sections: [TableSection] = []
   private var isMultiSection: Bool = false

   override func start() {
      view.delegate = self
      view.dataSource = self
      view.register(UITableViewCell.self, forCellReuseIdentifier: cellName)
   }
}

extension SimpleTableVM: Stateable {
   typealias State = ViewState
}

extension SimpleTableVM: Communicable {}

extension SimpleTableVM: UITableViewDelegate {
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      sendEvent(\.didSelectRow, payload: indexPath)
      tableView.deselectRow(at: indexPath, animated: true)
   }
}

extension SimpleTableVM: UITableViewDataSource {
   func numberOfSections(in tableView: UITableView) -> Int {
      isMultiSection ? sections.count : 1
   }

   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      isMultiSection ? sections[section].title : nil
   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      isMultiSection ? sections[section].models.count : models.count
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: cellName) ?? UITableViewCell()

      if events.cellForRow == nil {
         let model = isMultiSection ? sections[indexPath.section].models[indexPath.row] : models[indexPath.row]
         let modelView = model.uiView
         cell.contentView.subviews.forEach { $0.removeFromSuperview() }
         cell.contentView.addSubview(modelView)
         modelView.addAnchors.fitToView(cell.contentView)

         return cell
      } else {
         sendEvent(\.cellForRow, ({ viewModel in
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            cell.contentView.addSubview(viewModel.uiView)
            viewModel.uiView.addAnchors.fitToView(cell.contentView)
         }))

         return cell
      }
   }

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      UITableView.automaticDimension
   }

   func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
      UITableView.automaticDimension
   }
}

extension SimpleTableVM {
   @discardableResult func models(_ value: [UIViewModel]) -> Self {
      isMultiSection = false
      models = value
      view.reloadData()
      return self
   }

   @discardableResult func sections(_ value: [TableSection]) -> Self {
      isMultiSection = true
      sections = value
      view.reloadData()
      return self
   }
}
