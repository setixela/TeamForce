//
//  DiagramProfileVM.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 04.12.2022.
//

import ReactiveWorks

// MARK: - MyProfileVM

final class MyProfileVM<Design: DSP>: ScrollViewModelY, Designable {
   lazy var userBlock = ProfileUserBlock<Design>()
   lazy var userNameBlock = UserNameBlock<Design>()
   lazy var diagramBlock = DiagramVM()
      .height(132)
   lazy var userStatusBlock = UserStatusBlock<Design>()
   lazy var userContactsBlock = UserContactsBlock<Design>()
   lazy var workingPlaceBlock = WorkingPlaceBlock<Design>()
   lazy var userRoleBlock = UserRoleBlock<Design>()
   lazy var mapVM = MapsViewModel()
      .height(162)
      .cornerRadius(16)

   override func start() {
      super.start()

      set(.arrangedModels([
         userBlock,
         userNameBlock,
         userStatusBlock,
         diagramBlock,
         userContactsBlock,
         workingPlaceBlock,
         userRoleBlock,
         mapVM
      ]))
      set(.spacing(16))
   }
}

// MARK: - ProfileUserBlock

final class ProfileUserBlock<Design: DSP>: M<UserAvatarVM<Design>>.R<Spacer>.R2<ButtonModel>.Combo,
   Designable
{
   required init() {
      super.init()

      setAll { avatar, _, notifyButton in
         avatar.setState(.size(48))
         notifyButton
            .image(Design.icon.alarm, color: Design.color.iconContrast)
            .size(.square(36))
      }

      alignment(.center)
   }
}

// MARK: - UserNameBlock

final class UserNameBlock<Design: DSP>: M<LabelModel>.R<LabelModel>.LD<LabelModel>.Combo,
   Designable
{
   required init() {
      super.init()

      setAll { name, surname, nickname in
         name
            .set(Design.state.label.headline4)
         surname
            .set(Design.state.label.headline4)
            .textColor(Design.color.textBrand)
         nickname
            .set(Design.state.label.subtitle)
      }

      alignment(.leading)
   }
}

extension UserNameBlock: StateMachine {
   func setState(_ state: (name: String, surname: String, nickname: String)) {
      models.main.text(state.name)
      models.right.text(" " + state.surname)
      models.leftDown.text("@" + state.nickname)
   }
}

// MARK: - UserStatusBlock

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
            .textColor(Design.color.textInvert)
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
         models.right.text("В офисе")
      case .vacation:
         models.right.text("В отпуске")
      case .remote:
         models.right.text("На удаленке")
      case .sickLeave:
         models.right.text("На больничном")
      }
   }
}

// MARK: - DiagramVM

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
      let radius = (rect.height - arcWidth) / 2.0

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

// MARK: - UserContactsBlock

final class UserContactsBlock<Design: DSP>: StackModel, Designable {
   private lazy var title = LabelModel()
      .set(Design.state.label.body1)
      .text("Контактные данные")

   private lazy var surname = ProfileTitleBody<Design>
      { $0.title.text("Фамилия") }
   private lazy var name = ProfileTitleBody<Design>
      { $0.title.text("Имя") }
   private lazy var middlename = ProfileTitleBody<Design>
      { $0.title.text("Отчество") }
   private lazy var email = ProfileTitleBody<Design>
      { $0.title.text("Корпоративная почта") }
   private lazy var phone = ProfileTitleBody<Design>
      { $0.title.text("Мобильный номер") }
   private lazy var birthDate = ProfileTitleBody<Design>
      { $0.title.text("День рождения") }

   override func start() {
      spacing(16)
      arrangedModels(
         title,
         surname,
         name,
         middlename,
         email,
         phone,
         birthDate
      )
   }
}

extension UserContactsBlock: StateMachine {
   func setState(_ state: UserContactData) {
      surname.setBody(state.surname)
      name.setBody(state.name)
      middlename.setBody(state.patronymic)
      email.setBody(state.corporateEmail)
      phone.setBody(state.corporateEmail)
      birthDate.setBody(state.dateOfBirth)
   }
}

// MARK: - WorkingPlaceBlock

final class WorkingPlaceBlock<Design: DSP>: StackModel, Designable {
   private lazy var title = LabelModel()
      .set(Design.state.label.body1)
      .text("Место работы")

   private lazy var company = ProfileTitleBody<Design>
   { $0.title.text("Компания") }
   private lazy var jobTitle = ProfileTitleBody<Design>
   { $0.title.text("Должность") }

   override func start() {
      spacing(16)
      arrangedModels(
         title,
         company,
         jobTitle
      )
   }
}

extension WorkingPlaceBlock: StateMachine {
   func setState(_ state: UserWorkData) {
      company.setBody(state.company)
      jobTitle.setBody(state.jobTitle)
   }
}

// MARK: - UserRoleBlock

final class UserRoleBlock<Design: DSP>: StackModel, Designable {
   private lazy var role = ProfileTitleBody<Design>
   { $0.title.text("Роль") }

   override func start() {
      spacing(16)
      arrangedModels(
         role
      )
   }
}

extension UserRoleBlock: StateMachine {
   func setState(_ state: UserRoleData) {
      role.setBody(state.role)
   }
}

// MARK: - UserLocationBlock

final class UserLocationBlock<Design: DSP>: StackModel, Designable {
   private lazy var title = LabelModel()
      .set(Design.state.label.body1)
      .text("Местоположение")

   private lazy var adress = ProfileTitleBody<Design>
   { $0.title.text("Адрес") }
   private lazy var map = MapsViewModel()

   override func start() {
      spacing(16)
      arrangedModels(
         title,
         adress,
         map
      )
   }
}

extension UserLocationBlock: StateMachine {
   func setState(_ state: UserLocationData) {
      adress.setBody(state.locationName)
      let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
      let region = MKCoordinateRegion(center: state.geoPosition, span: span)
      map.setState(.region(region))
   }
}

// MARK: - MapsViewModel

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

extension MapsViewModel: StateMachine {
   enum MapState {
      case region(MKCoordinateRegion)
   }

   func setState(_ state: MapState) {
      switch state {
      case .region(let region):
         view.region = region
      }
   }
}


