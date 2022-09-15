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
   var didSelectRow: (IndexPath, Int)?

   // TODO: - Обьединять ивенты как Стейты
   var didScroll: CGFloat?
   var willEndDragging: CGFloat?
}

final class TableItemsModel<Design: DSP>: BaseViewModel<UITableView>,
   Designable,
   Presenting,
   UITableViewDelegate,
   UITableViewDataSource
{
   typealias Events = TableItemsEvents
   var events: EventsStore = .init()

   private var isMultiSection: Bool = false

   var presenters: [String: PresenterProtocol] = [:]

   private var items: [Any] = []
   private var itemSections: [TableItemsSection] = []

   private var prevScrollOffset: CGFloat = 0
  // private var velocity: CGFloat = 0

   // MARK: - Start

   override func start() {
      view.delegate = self
      view.dataSource = self
      view.separatorColor = .clear
      view.clipsToBounds = true
      view.layer.masksToBounds = true

      backColor(Design.color.background)

      if #available(iOS 15.0, *) {
         view.sectionHeaderTopPadding = 0
      }
   }

   // MARK: -  UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      var rowNumber = indexPath.row

      for i in 0 ..< indexPath.section {
         rowNumber += view.numberOfRows(inSection: i)
      }

      send(\.didSelectRow, (indexPath, rowNumber))
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

      view.register(TableCell.self, forCellReuseIdentifier: cellName)

      let cell = tableView.dequeueReusableCell(withIdentifier: cellName) ?? TableCell()

      let presenter = presenters[cellName]
      let model = presenter?.viewModel(for: item)
      let modelView = model?.uiView ?? UIView()

      cell.contentView.backgroundColor = Design.color.background
      cell.contentView.subviews.forEach { $0.removeFromSuperview() }
      cell.contentView.addSubview(modelView)
      modelView.addAnchors.fitToView(cell.contentView)
//      cell.selectionStyle = .none

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
         .set(Design.state.label.title)
         .padding(.init(top: 4, left: 16, bottom: 4, right: 16))
         .text(text)
         .backColor(Design.color.background)
         .uiView

      return view
   }

   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      guard isMultiSection else { return 0 }

      return 36
   }

   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let velocity = scrollView.contentOffset.y - prevScrollOffset
      prevScrollOffset = scrollView.contentOffset.y
      send(\.didScroll, velocity)
   }

   func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                  withVelocity velocity: CGPoint,
                                  targetContentOffset: UnsafeMutablePointer<CGPoint>) {
      send(\.willEndDragging, velocity.y)
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

extension TableItemsModel: Eventable {}

final class TableCell: UITableViewCell {
   override func prepareForReuse() {
      super.prepareForReuse()
   }
}
