//
//  Labels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 23.06.2022.
//

import ReactiveWorks

protocol TypographyElements: InitProtocol, DesignElementable {
   var `default`: DesignElement { get }

   var headline2: DesignElement { get }
   var headline3: DesignElement { get }
   var headline4: DesignElement { get }
   var headline5: DesignElement { get }
   var headline6: DesignElement { get }

   var title: DesignElement { get }
   var title2: DesignElement { get }

   var body1: DesignElement { get }
   var body2: DesignElement { get }
   var body3: DesignElement { get }

   var subtitle: DesignElement { get }
   var caption: DesignElement { get }
   var caption2: DesignElement { get }
   var counter: DesignElement { get }
}

// MARK: - Labels Protocol

protocol LabelProtocol: TypographyElements
   where DesignElement == LabelModel {}

// MARK: - Labels

struct LabelBuilder<Design: DSP>: LabelProtocol, Designable {
   var subtitle: LabelModel { .init(Design.state.label.subtitle) }
   var `default`: LabelModel { .init(Design.state.label.default) }

   var headline2: LabelModel { .init(Design.state.label.headline2) }
   var headline3: LabelModel { .init(Design.state.label.headline3) }
   var headline4: LabelModel { .init(Design.state.label.headline4) }
   var headline5: LabelModel { .init(Design.state.label.headline5) }
   var headline6: LabelModel { .init(Design.state.label.headline6) }

   var title: LabelModel { .init(Design.state.label.title) }
   var title2: LabelModel { .init(Design.state.label.title2) }

   var body1: LabelModel { .init(Design.state.label.body1) }
   var body2: LabelModel { .init(Design.state.label.body2) }
   var body3: LabelModel { .init(Design.state.label.body3) }

   var caption: LabelModel { .init(Design.state.label.caption) }
   var caption2: LabelModel { .init(Design.state.label.caption2) }
   var counter: LabelModel { .init(Design.state.label.counter) }
}

protocol LabelStateProtocol: TypographyElements where DesignElement == [LabelState] {}

struct LabelStateBuilder<Design: DSP>: LabelStateProtocol, Designable {
   var `default`: [LabelState] { [
      .font(.systemFont(ofSize: 14, weight: .regular)),
      .textColor(.black)
   ] }

   var headline2: [LabelState] { [
      .font(.systemFont(ofSize: 54, weight: .semibold)),
      .textColor(.black)
   ] }

   var headline3: [LabelState] { [
      .font(.systemFont(ofSize: 48, weight: .regular)),
      .textColor(.black)
   ] }

   var headline4: [LabelState] { [
      .font(.systemFont(ofSize: 32, weight: .bold)),
      .textColor(.black)
   ] }

   var headline5: [LabelState] { [
      .font(.systemFont(ofSize: 28, weight: .bold)),
      .textColor(.black)
   ] }

   var headline6: [LabelState] { [
      .font(.systemFont(ofSize: 20, weight: .regular)),
      .textColor(.black)
   ] }

   var title: [LabelState] { [
      .font(.systemFont(ofSize: 24, weight: .bold)),
      .textColor(.black)
   ] }

   var title2: [LabelState] { [
      .font(.systemFont(ofSize: 24, weight: .medium)),
      .textColor(.black)
   ] }

   var body1: [LabelState] { [
      .font(.systemFont(ofSize: 16, weight: .regular)),
      .textColor(.black)
   ] }

   var body2: [LabelState] { [
      .font(.systemFont(ofSize: 14, weight: .semibold)),
      .textColor(.black)
   ] }

   var body3: [LabelState] { [
      .font(.systemFont(ofSize: 16, weight: .semibold)),
      .textColor(.black)
   ] }

   var subtitle: [LabelState] { [
      .font(.systemFont(ofSize: 16, weight: .regular)),
      .textColor(.black)
   ] }

   var caption: [LabelState] { [
      .font(.systemFont(ofSize: 12, weight: .regular)),
      .textColor(.black)
   ] }

   var caption2: [LabelState] { [
      .font(.systemFont(ofSize: 10, weight: .regular)),
      .textColor(.black)
   ] }

   var counter: [LabelState] { [
      .font(.systemFont(ofSize: 48, weight: .regular)),
      .textColor(.black)
   ] }
}
