//
//  Labels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 23.06.2022.
//

import ReactiveWorks

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
   var body1: LabelModel { .init(Design.state.label.body1) }
   var body2: LabelModel { .init(Design.state.label.body2) }
   var caption: LabelModel { .init(Design.state.label.caption) }
   var counter: LabelModel { .init(Design.state.label.counter) }
}

protocol LabelStateProtocol: TypographyElements where DesignElement == [LabelState] {}

struct LabelStateBuilder<Design: DSP>: LabelStateProtocol, Designable {

   var `default`: [LabelState] { [
      .font(Design.font.default),
      .color(.black)
   ] }

   var headline2: [LabelState] { [
      .font(Design.font.headline2),
      .color(.black)
   ] }

   var headline3: [LabelState] { [
      .font(Design.font.headline3),
      .color(.black)
   ] }

   var headline4: [LabelState] { [
      .font(Design.font.headline4),
      .color(.black)
   ] }

   var headline5: [LabelState] { [
      .font(Design.font.headline5),
      .color(.black)
   ] }

   var headline6: [LabelState] { [
      .font(Design.font.headline6),
      .color(.black)
   ] }

   var title: [LabelState] { [
      .font(Design.font.title),
      .color(.black)
   ] }

   var body1: [LabelState] { [
      .font(Design.font.body1),
      .color(.black)
   ] }

   var body2: [LabelState] { [
      .font(Design.font.body2),
      .color(.black)
   ] }

   var subtitle: [LabelState] { [
      .font(Design.font.subtitle),
      .color(.black)
   ] }

   var caption: [LabelState] { [
      .font(Design.font.caption),
      .color(.black)
   ] }

   var counter: [LabelState] { [
      .font(Design.font.counter),
      .color(.black)
   ] }
}
