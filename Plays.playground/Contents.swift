//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import UIKit

class MyViewController: UIViewController {
   override func loadView() {
      let view = UIView()
      view.backgroundColor = .white

      let graphs = CircleGraphs(graphs: [
         .init(percent: 0.25, color: .red),
         .init(percent: 0.25, color: .blue),
         .init(percent: 0.5, color: .green),
      ])

      let graph = GraphView(frame: .init(x: 0, y: 0, width: 132, height: 132))
      view.addSubview(graph)
      self.view = view

      graph.drawGraphs(graphs)
   }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

final class GraphView: UIView {}

extension GraphView: CircleGraphProtocol {
   func drawGraphs(_ graphs: CircleGraphs) {

      let arcWidth: CGFloat = 19.8

      let fullCircle = 2 * CGFloat.pi

      let centerPoint = CGPoint(x: frame.midX, y: frame.midY)

      let radius: CGFloat
      if frame.width > frame.height {
         radius = (frame.width - arcWidth) / 2.0
      } else {
         radius = (frame.height - arcWidth) / 2.0
      }

      var currentStart: CGFloat = -0.25
      graphs.graphs.forEach {
         let percent = $0.percent
         let arcLength = percent
         let endArc: CGFloat = currentStart + arcLength

         let start: CGFloat = (currentStart) * fullCircle
         let end = endArc * fullCircle

         print(start)
         print(arcLength)
         print()

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
            x: centerPoint.x + cos(arcCenter) * (frame.width - arcWidth) / 2,
            y: centerPoint.y + sin(arcCenter) * (frame.height - arcWidth) / 2
         )
         print("pos \(textPos)")
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

protocol CircleGraphProtocol {
   func drawGraphs(_ graphs: CircleGraphs)
}

struct CircleGraphs {
   let graphs: [GraphData]
}

struct GraphData {
   let percent: CGFloat
   let color: UIColor
}
