//
//  ScrollViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 23.11.2022.
//

import ReactiveWorks
import UIKit

class ScrollViewModel: BaseViewModel<ScrollViewExtended>, UIScrollViewDelegate, Stateable {
   var events: EventsStore = .init()

   typealias State = ViewState

   private lazy var zoomingTap: UITapGestureRecognizer = {
      let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
      zoomingTap.numberOfTapsRequired = 2
      return zoomingTap
   }()

   override func start() {
      super.start()
   }

   func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      let zoomView = view.subviews.first
      return zoomView
   }

   @objc private func handleZoomingTap(sender: UITapGestureRecognizer) {
      let location = sender.location(in: sender.view)
      zoom(point: location, animated: true)
   }

   private func zoom(point: CGPoint, animated: Bool) {
      let currentScale = view.zoomScale
      let minScale = view.minimumZoomScale
      let maxScale = view.maximumZoomScale

      if minScale == maxScale, minScale > 1 {
         return
      }

      let toScale = maxScale
      let finalScale = (currentScale == minScale) ? toScale : minScale
      let zoomRect = zoomRect(scale: finalScale, center: point)
      view.zoom(to: zoomRect, animated: animated)
   }

   private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
      var zoomRect = CGRect.zero
      let bounds = view.bounds

      zoomRect.size.width = bounds.size.width / scale
      zoomRect.size.height = bounds.size.height / scale

      zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
      zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
      return zoomRect
   }

   private func configurateFor(size: CGSize) {
      view.contentSize = size

     // setCurrentMaxAndMinZoomScale()
      view.zoomScale = view.minimumZoomScale

      guard let imageZoomView = viewForZooming(in: view) else { return }

      imageZoomView.addGestureRecognizer(zoomingTap)
      imageZoomView.isUserInteractionEnabled = true
   }

   private func setCurrentMaxAndMinZoomScale() {
      guard let imageZoomView = viewForZooming(in: view) else { return }

      let boundsSize = view.bounds.size
      print(boundsSize)
      let imageSize = imageZoomView.bounds.size
      print(imageSize)
      let xScale = boundsSize.width / imageSize.width
      let yScale = boundsSize.height / imageSize.height
      let minScale = min(xScale, yScale)

      var maxScale: CGFloat = 1.0
      if minScale < 0.1 {
         maxScale = 0.3
      }
      if minScale >= 0.1, minScale < 0.5 {
         maxScale = 0.7
      }
      if minScale >= 0.5 {
         maxScale = max(1.0, minScale)
      }

      view.minimumZoomScale = minScale
      view.maximumZoomScale = maxScale
   }
}

extension ScrollViewModel {
   @discardableResult func viewModel(_ value: UIViewModel) -> Self {
      let uiView = value.uiView
      view.subviews.forEach { $0.removeFromSuperview() }
      view.addSubview(uiView)
      uiView.addAnchors
//         .fitToView(view)
         .height(view.heightAnchor)
         .width(view.widthAnchor)
         .centerY(view.centerYAnchor)

      return self
   }

   @discardableResult func hideHorizontalScrollIndicator() -> Self {
      view.showsHorizontalScrollIndicator = false
      return self
   }

   @discardableResult func hideVerticalScrollIndicator() -> Self {
      view.showsVerticalScrollIndicator = false
      return self
   }

   @discardableResult func bounces(_ value: Bool) -> Self {
      view.bounces = value
      return self
   }

   @discardableResult func zooming(min: CGFloat, max: CGFloat) -> Self {
      view.delegate = self
      view.maximumZoomScale = max
      view.minimumZoomScale = min
      return self
   }

   @discardableResult func disableScroll() -> Self {
      view.isScrollEnabled = false
      return self
   }

   @discardableResult func doubleTapForZooming() -> Self {
      view.delegate = self

      guard let subview = viewForZooming(in: view) else {
         return self
      }

      guard let image = (subview as? UIImageView)?.image else {
         configurateFor(size: subview.bounds.size)
         return self
      }
      let size = image.size

      configurateFor(size: size)

      return self
   }
}
