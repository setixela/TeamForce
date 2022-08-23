//
//  TableItemsModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 17.08.2022.
//

import ReactiveWorks
import UIKit

class TableItemsSection {
   let title: String
   var items: [Any] = []

   init(title: String) {
      self.title = title
   }
}

enum TableItemsState {
   case items([Any])
   case itemSections([TableItemsSection])
   case presenters([PresenterProtocol])
}

struct TableItemsEvents: InitProtocol {
   var didSelectRow: Event<(IndexPath, Int)>?
}

final class TableItemsModel<Design: DSP>: BaseViewModel<UITableView>,
   Designable,
   Presenting,
   UITableViewDelegate,
   UITableViewDataSource
{
   var events: TableItemsEvents = .init()

   private var isMultiSection: Bool = false

   var presenters: [String: PresenterProtocol] = [:]

   private var items: [Any] = []
   private var itemSections: [TableItemsSection] = []

   override func start() {
      view.delegate = self
      view.dataSource = self
   //   view.separatorColor = .clear
      view.clipsToBounds = false
      view.layer.masksToBounds = true

      if #available(iOS 15.0, *) {
         view.sectionHeaderTopPadding = 0
      }
   }

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      var rowNumber = indexPath.row
      
      for i in 0..<indexPath.section {
         rowNumber += view.numberOfRows(inSection: i)
      }
      
      sendEvent(\.didSelectRow, payload: (indexPath, rowNumber))
      tableView.deselectRow(at: indexPath, animated: true)
   }

   func numberOfSections(in tableView: UITableView) -> Int {
      isMultiSection ? itemSections.count : 1
   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      isMultiSection ? itemSections[section].items.count : items.count
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let item = isMultiSection ? itemSections[indexPath.section].items[indexPath.row] : items[indexPath.row]

      let cellName = String(describing: type(of: item))

      view.register(UITableViewCell.self, forCellReuseIdentifier: cellName)

      let cell = tableView.dequeueReusableCell(withIdentifier: cellName) ?? UITableViewCell()

      let presenter = presenters[cellName]
      let modelView = presenter?.viewModel(for: item).uiView ?? UIView()

      cell.contentView.subviews.forEach { $0.removeFromSuperview() }
      cell.contentView.addSubview(modelView)
      modelView.addAnchors.fitToView(cell.contentView)
      cell.selectionStyle = .none

      return cell
   }

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      UITableView.automaticDimension
   }

   func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
      UITableView.automaticDimension
   }

   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      guard isMultiSection else { return nil }

      let text = itemSections[section].title
      let view = LabelModel()
         .set_font(Design.font.title)
         .set_padding(.init(top: 4, left: 16, bottom: 4, right: 16))
         .set_text(text)
         .set_backColor(Design.color.background)
         .uiView

      return view
   }

   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      guard isMultiSection else { return 0 }

      return 36
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
            let key = $0.cellType
            self.presenters[key] = $0
         }
      }
   }
}

extension TableItemsModel: Communicable {}
