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

protocol ScrollEventsProtocol: InitProtocol {
   // TODO: - Обьединять ивенты как Стейты
   var didScroll: CGFloat? { get set }
   var willEndDragging: CGFloat? { get set }
}

struct TableItemsEvents: ScrollEventsProtocol {
   var didSelectRow: (IndexPath, Int)?
   var didSelectRowInt: Int?

   var presentedIndex: Int?

   // TODO: - Обьединять ивенты как Стейты
   var didScroll: CGFloat?
   var willEndDragging: CGFloat?
   var pagination: Bool?

   // refresh
   var refresh: Void?
}

final class TableItemsModel<Design: DSP>: BaseViewModel<TableViewExtended>,
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

   private lazy var refreshControl = UIRefreshControl()

   // MARK: - Start

   override func start() {
      view.delegate = self
      view.dataSource = self
      view.separatorColor = .clear
      view.clipsToBounds = true
      view.layer.masksToBounds = true
      view.rowHeight = UITableView.automaticDimension
      view.estimatedRowHeight = UITableView.automaticDimension

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
      send(\.didSelectRowInt, rowNumber)
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
      let model = presenter?.viewModel(for: item, index: indexPath.row)
      let modelView = model?.uiView ?? UIView()

      cell.contentView.backgroundColor = Design.color.background
      cell.contentView.subviews.forEach { $0.removeFromSuperview() }
      cell.contentView.addSubview(modelView)
      modelView.addAnchors.fitToView(cell.contentView)
      cell.contentView.setNeedsLayout()

      send(\.presentedIndex, indexPath.row)

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

      let pos = scrollView.contentOffset.y
      if pos > view.contentSize.height - 50 - scrollView.frame.size.height {
         send(\.pagination, true)
      }
   }

   func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                  withVelocity velocity: CGPoint,
                                  targetContentOffset: UnsafeMutablePointer<CGPoint>)
   {
      send(\.willEndDragging, velocity.y)
   }

   // Refresh

   @objc func refresh(_ sender: AnyObject) {
      view.isScrollEnabled = false
      send(\.refresh)
      refreshControl.endRefreshing()
      view.isScrollEnabled = true
   }
}

extension TableItemsModel: Stateable {
   typealias State = ViewState
}

extension TableItemsModel: Eventable {}

extension TableItemsModel {
   @discardableResult func items(_ value: [Any]) -> Self {
      items = value
      view.reloadData()
      return self
   }

   @discardableResult func itemSections(_ value: [TableItemsSection]) -> Self {
      itemSections = value
      isMultiSection = true
      view.reloadData()
      return self
   }

   @discardableResult func presenters(_ value: PresenterProtocol...) -> Self {
      presenters.removeAll()
      value.forEach {
         let key = $0.cellType
         self.presenters[key] = $0
      }
      return self
   }

   @discardableResult func updateItemAtIndex(_ value: Any, index: Int) -> Self {
      items[index] = value
      let indexPath = IndexPath(item: index, section: 0)
      view.reloadRows(at: [indexPath], with: .automatic)
      return self
   }

   @discardableResult func separatorStyle(_ value: UITableViewCell.SeparatorStyle) -> Self {
      view.separatorStyle = value
      return self
   }

   @discardableResult func separatorColor(_ value: UIColor) -> Self {
      view.separatorColor = value
      return self
   }

   @discardableResult func reload() -> Self {
      view.reloadData()
      return self
   }

   @discardableResult func activateRefreshControl(text: String = "", color: UIColor? = nil) -> Self {
      refreshControl.attributedTitle = NSAttributedString(string: text)
      refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
      refreshControl.tintColor = color ?? refreshControl.tintColor
      refreshControl.transform = CGAffineTransformMakeScale(0.70, 0.70);
      view.refreshControl = refreshControl
      return self
   }
}

final class TableCell: UITableViewCell {
   override func prepareForReuse() {
      super.prepareForReuse()
   }
}
