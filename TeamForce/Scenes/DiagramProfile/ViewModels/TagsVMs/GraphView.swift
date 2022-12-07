//
//  GraphView.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.12.2022.
//

import UIKit

protocol CircleGraphProtocol {
   func drawGraphs(_ graphs: [GraphData])
}

struct GraphData {
   let percent: CGFloat
   let color: UIColor
}

final class GraphView: UIView {}

extension GraphView: CircleGraphProtocol {
   func drawGraphs(_ graphs: [GraphData]) {
      let rect = bounds
      let arcWidth: CGFloat = 19.8
      let fullCircle = 2 * CGFloat.pi
      let centerPoint = CGPoint(x: rect.midX, y: rect.midY)
      let radius = (rect.height - arcWidth) / 2.0

      var currentStart: CGFloat = -0.25
      graphs.forEach {
         let percent = $0.percent
         let arcLength = percent
         let endArc: CGFloat = currentStart + arcLength

         let start: CGFloat = currentStart * fullCircle
         let end = endArc * fullCircle

         let path = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius,
            startAngle: start,
            endAngle: end,
            clockwise: true
         )

         let shapeLayer = CAShapeLayer()
         shapeLayer.path = path.cgPath
         shapeLayer.strokeColor = $0.color.cgColor
         shapeLayer.fillColor = CGColor(gray: 0, alpha: 0)
         shapeLayer.lineCap = .round
         shapeLayer.lineWidth = arcWidth

         layer.addSublayer(shapeLayer)

         let arcCenter = (start + end) / 2
         let textPos = CGPoint(
            x: centerPoint.x + cos(arcCenter) * (rect.height - arcWidth) / 2,
            y: centerPoint.y + sin(arcCenter) * (rect.height - arcWidth) / 2
         )

         let label = UILabel()

         label.textColor = .white
         let text = String(describing: Int(percent * 100)) + "%"
         label.font = .systemFont(ofSize: 8, weight: .bold)
         label.text = text
         label.sizeToFit()
         label.center = .init(
            x: textPos.x,
            y: textPos.y
         )
         addSubview(label)

         currentStart += arcLength
      }
   }
}