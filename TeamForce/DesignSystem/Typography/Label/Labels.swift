//
//  Labels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 23.06.2022.
//

import ReactiveWorks

// MARK: - Labels Protocol

protocol LabelProtocol: TypographyElements
   where DesignElement == LabelModel
{
   associatedtype State: LabelStateProtocol

   var state: State { get }
}

// MARK: - Labels

final class LabelBuilder: LabelProtocol {
   let state = LabelStateBuilder()

   var subtitle: LabelModel { .init(state.subtitle) }
   var `default`: LabelModel { .init(state.default) }

   var headline2: LabelModel { .init(state.headline2) }
   var headline3: LabelModel { .init(state.headline3) }
   var headline4: LabelModel { .init(state.headline4) }
   var headline5: LabelModel { .init(state.headline5) }
   var headline6: LabelModel { .init(state.headline6) }

   var title: LabelModel { .init(state.title) }
   var body1: LabelModel { .init(state.body1) }
   var body2: LabelModel { .init(state.body2) }
   var caption: LabelModel { .init(state.caption) }
   var counter: LabelModel { .init(state.counter) }
}

protocol LabelStateProtocol: TypographyElements where DesignElement == [LabelState] {
   associatedtype Fonts: FontProtocol
}

struct LabelStateBuilder: LabelStateProtocol {
   typealias Fonts = FontBuilder

   private let fonts = Fonts()

   var `default`: [LabelState] { [
      .font(fonts.default),
      .color(.black)
   ] }

   var headline2: [LabelState] { [
      .font(fonts.headline2),
      .color(.black)
   ] }

   var headline3: [LabelState] { [
      .font(fonts.headline3),
      .color(.black)
   ] }

   var headline4: [LabelState] { [
      .font(fonts.headline4),
      .color(.black)
   ] }

   var headline5: [LabelState] { [
      .font(fonts.headline5),
      .color(.black)
   ] }

   var headline6: [LabelState] { [
      .font(fonts.headline6),
      .color(.black)
   ] }

   var title: [LabelState] { [
      .font(fonts.title),
      .color(.black)
   ] }

   var body1: [LabelState] { [
      .font(fonts.body1),
      .color(.black)
   ] }

   var body2: [LabelState] { [
      .font(fonts.body2),
      .color(.black)
   ] }

   var subtitle: [LabelState] { [
      .font(fonts.subtitle),
      .color(.black)
   ] }

   var caption: [LabelState] { [
      .font(fonts.caption),
      .color(.black)
   ] }

   var counter: [LabelState] { [
      .font(fonts.counter),
      .color(.black)
   ] }
}
