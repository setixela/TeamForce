//
//  ScrollViewModels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.08.2022.
//

import ReactiveWorks
import UIKit

enum ScrollState {
   case arrangedModels([UIViewModel])
   case spacing(CGFloat)
   case scrollToTop(animated: Bool)
   case hideHorizontalScrollIndicator
   case hideVerticalScrollIndicator
   case padding(UIEdgeInsets)
   case contentInset(UIEdgeInsets)
   case bounce(Bool)
}

struct ScrollEvents: ScrollEventsProtocol {
   var didScroll: CGFloat?
   var willEndDragging: CGFloat?
   var willBeginDragging: Void?
   var willBeginDecelerating: Void?
}

protocol ScrollWrapper: UIScrollViewDelegate, Eventable where Events == ScrollEvents {}

class ScrollViewModelY: BaseViewModel<UIScrollView>, ScrollWrapper, Stateable {
   var events: ReactiveWorks.EventsStore = .init()

   typealias State = ViewState

   private var prevScrollOffset: CGFloat = 0

   lazy var stack = StackModel()
      .axis(.vertical)
      .distribution(.equalSpacing)

   private var spacing: CGFloat = 0

   override func start() {
      view.addSubview(stack.uiView)
      view.delegate = self

      view.isDirectionalLockEnabled = true
      view.showsHorizontalScrollIndicator = false
      view.layer.masksToBounds = false
      stack.view.addAnchors
         .top(view.topAnchor)
         .leading(view.leadingAnchor)
         .trailing(view.trailingAnchor)
         .bottom(view.bottomAnchor)
         .width(view.widthAnchor)
   }

   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let velocity = scrollView.contentOffset.y - prevScrollOffset
      scrollView.contentOffset.x = 0
      prevScrollOffset = scrollView.contentOffset.y
      send(\.didScroll, velocity)
   }

   func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                  withVelocity velocity: CGPoint,
                                  targetContentOffset: UnsafeMutablePointer<CGPoint>)
   {
      send(\.willEndDragging, velocity.y)
   }

   func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
      send(\.willBeginDragging)
   }

   func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
      send(\.willBeginDecelerating)
   }
}

extension ScrollViewModelY: Stateable2 {
   func applyState(_ state: ScrollState) {
      switch state {
      case .arrangedModels(let array):
         stack.view.subviews.forEach {
            $0.removeFromSuperview()
         }
         array.forEach {
            stack.view.addArrangedSubview($0.uiView)
         }
      case .spacing(let value):
         stack.view.spacing = value
      case .scrollToTop(let value):
         view.setContentOffset(.zero, animated: value)
      case .hideHorizontalScrollIndicator:
         view.showsHorizontalScrollIndicator = false
      case .hideVerticalScrollIndicator:
         view.showsVerticalScrollIndicator = false
      case .padding(let value):
         stack.padding(value)
      case .contentInset(let value):
         stack.view.addAnchors.fitToViewInsetted(view, value)
//         let pos = stack.view.frame.origin
//         let siz = stack.view.frame.size
//         let frame = CGRect(x: pos.x + value.left,
//                                  y: pos.y + value.top,
//                                  width: siz.width - value.right - value.left,
//                                  height: siz.height - value.bottom - value.top)
//         stack.view.frame = frame
      case .bounce(let value):
         view.bounces = value
      }
   }
}

class ScrollViewModelX: BaseViewModel<UIScrollView>, ScrollWrapper {
   var events: ReactiveWorks.EventsStore = .init()

   private lazy var stack = StackModel()
      .axis(.horizontal)

   private var spacing: CGFloat = 0

   override func start() {
      view.addSubview(stack.uiView)

      view.layer.masksToBounds = false
      stack.view.addAnchors
         .top(view.topAnchor)
         .leading(view.leadingAnchor)
         .trailing(view.trailingAnchor)
         .height(view.heightAnchor)
   }
}

extension ScrollViewModelX: Stateable2 {
   func applyState(_ state: ScrollState) {
      switch state {
      case .arrangedModels(let array):
         stack.view.subviews.forEach {
            $0.removeFromSuperview()
         }
         array.enumerated().forEach {
            stack.view.addArrangedSubview($0.1.uiView)
         }
      case .spacing(let value):
         stack.view.spacing = value
      case .scrollToTop(let value):
         view.setContentOffset(.zero, animated: value)
      case .hideHorizontalScrollIndicator:
         view.showsHorizontalScrollIndicator = false
      case .hideVerticalScrollIndicator:
         view.showsVerticalScrollIndicator = false
      case .padding(let value):
         stack.padding(value)
      case .contentInset(let value):
         view.contentInset = value
      case .bounce(let value):
         view.bounces = value
      }
   }
}
