//
//  DiagramProfileVM.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 04.12.2022.
//

import ReactiveWorks

final class MyProfileVM<Design: DSP>: StackModel, Designable {
   lazy var userBlock = ProfileUserBlock<Design>()
   lazy var userNameBlock = UserNameBlock<Design>()
   lazy var diagramBlock = DiagramVM()
      .height(132)
   lazy var userStatusBlock = UserStatusBlock<Design>()
   lazy var mapVM = MapsViewModel()
      .height(162)
      .cornerRadius(16)

   override func start() {
      super.start()

      arrangedModels(
         userBlock,
         userNameBlock,
         userStatusBlock,
         diagramBlock,
         mapVM
      )
      spacing(16)
   }
}

final class ProfileUserBlock<Design: DSP>: M<UserAvatarVM<Design>>.R<Spacer>.R2<ButtonModel>.Combo,
   Designable
{
   required init() {
      super.init()

      setAll { avatar, _, notifyButton in
         avatar.setState(.size(48))
         notifyButton
            // .set(Design.state.button.transparent)
            .image(Design.icon.alarm, color: Design.color.iconContrast)
            .size(.square(36))
      }

      alignment(.center)
   }
}

final class UserNameBlock<Design: DSP>: M<LabelModel>.R<LabelModel>.D<LabelModel>.Combo,
   Designable
{
   required init() {
      super.init()

      setAll { surname, name, nickname in
         name
            .set(Design.state.label.headline4)
         surname
            .set(Design.state.label.headline4)
            .textColor(Design.color.textBrand)
         nickname
            .set(Design.state.label.subtitle)
      }
   }
}

extension UserNameBlock: StateMachine {
   enum ModelState {
      case setup(name: String, surname: String, nickname: String)
   }

   func setState(_ state: ModelState) {
      switch state {
      case let .setup(name, surname, nickname):
         models.main.text(name)
         models.right.text(surname)
         models.down.text(nickname)
      }
   }
}

enum UserStatus {
   case office
   case vacation
   case remote
   case sickLeave
}

final class UserStatusBlock<Design: DSP>: M<LabelModel>.R<LabelModel>.Combo,
   Designable
{
   required init() {
      super.init()

      setAll { title, status in
         title
            .set(Design.state.label.body3)
            .textColor(Design.color.textInvert)
            .text("Статус")
         status
            .set(Design.state.label.default)
      }

      backColor(Design.color.backgroundBrand)
      cornerRadius(Design.params.cornerRadius)
      padding(.outline(16))
   }
}

extension UserStatusBlock: StateMachine {
   func setState(_ state: UserStatus) {
      switch state {
      case .office:
         models.right.text("В оффисе")
      case .vacation:
         models.right.text("В отпуске")
      case .remote:
         models.right.text("На удаленке")
      case .sickLeave:
         models.right.text("На больничном")
      }
   }
}

import MapKit

final class MapsViewModel: BaseViewModel<MKMapView> {
   override func start() {
      view.isZoomEnabled = false
      view.isScrollEnabled = false
      view.showsUserLocation = true
   }
}

extension MapsViewModel: Stateable {
   typealias State = ViewState
}

final class DiagramVM: BaseViewModel<GraphView> {
   override func start() {}
}

extension DiagramVM: Stateable {
   typealias State = ViewState
}

extension DiagramVM: StateMachine {
   func setState(_ state: CircleGraphs) {
      view.drawGraphs(state)
   }
}

final class GraphView: UIView {}

extension GraphView: CircleGraphProtocol {
   func drawGraphs(_ graphs: CircleGraphs) {
      let rect = bounds
      let arcWidth: CGFloat = 19.8
      let fullCircle = 2 * CGFloat.pi
      let centerPoint = CGPoint(x: rect.midX, y: rect.midY)

  //    let radius: CGFloat
      let radius = (rect.height - arcWidth) / 2.0
//      if rect.width > rect.height {
//         radius = (rect.width - arcWidth) / 2.0
//      } else {
//         radius = (rect.height - arcWidth) / 2.0
//      }

      var currentStart: CGFloat = -0.25
      graphs.graphs.forEach {
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
