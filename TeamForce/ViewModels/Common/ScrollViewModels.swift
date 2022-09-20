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
}

struct ScrollEvents: ScrollEventsProtocol {
   var didScroll: CGFloat?
   var willEndDragging: CGFloat?
}

protocol ScrollWrapper: UIScrollViewDelegate, Eventable where Events == ScrollEvents {}

final class ScrollViewModelY: BaseViewModel<UIScrollView>, ScrollWrapper {
   var events: ReactiveWorks.EventsStore = .init()

   private var prevScrollOffset: CGFloat = 0

   private lazy var stack = StackModel()
      .axis(.vertical)
      .distribution(.equalSpacing)

   private var spacing: CGFloat = 0

   override func start() {
      view.addSubview(stack.uiView)
      view.delegate = self

      stack.view.addAnchors
         .top(view.topAnchor)
         .leading(view.leadingAnchor)
         .trailing(view.trailingAnchor)
         .bottom(view.bottomAnchor)
         .width(view.widthAnchor)
   }

   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let velocity = scrollView.contentOffset.y - prevScrollOffset
      prevScrollOffset = scrollView.contentOffset.y
      send(\.didScroll, velocity)
   }

   func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                  withVelocity velocity: CGPoint,
                                  targetContentOffset: UnsafeMutablePointer<CGPoint>)
   {
      send(\.willEndDragging, velocity.y)
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
      }
   }
}

final class ScrollViewModelX: BaseViewModel<UIScrollView>, ScrollWrapper {
   var events: ReactiveWorks.EventsStore = .init()

   private lazy var stack = StackModel()
      .axis(.horizontal)

   private var spacing: CGFloat = 0

   override func start() {
      view.addSubview(stack.uiView)

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
      }
   }
}
