//
//  Labels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 23.06.2022.
//

import ReactiveWorks

protocol TypographyElements: InitProtocol, DesignElementable {
   var `default`: DesignElement { get }
   var defaultBrand: DesignElement { get }
   var defaultError: DesignElement { get }

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
   var body4: DesignElement { get }

   var subtitle: DesignElement { get }
   var subtitleSecondary: DesignElement { get }

   var caption: DesignElement { get }
   var captionSecondary: DesignElement { get }
   var captionError: DesignElement { get }
   var caption2: DesignElement { get }

   var counter: DesignElement { get }
}

// MARK: - Labels Protocol

protocol LabelProtocol: TypographyElements where DesignElement == LabelModel {}

// MARK: - Labels

struct LabelBuilder<Design: DSP>: LabelProtocol, Designable {
   var `default`: LabelModel { .init(Design.state.label.default) }
   var defaultBrand: LabelModel { .init(Design.state.label.defaultBrand) }
   var defaultError: LabelModel { .init(Design.state.label.defaultError) }

   var headline2: LabelModel { .init(Design.state.label.headline2) }
   var headline3: LabelModel { .init(Design.state.label.headline3) }
   var headline4: LabelModel { .init(Design.state.label.headline4) }
   var headline5: LabelModel { .init(Design.state.label.headline5) }
   var headline6: LabelModel { .init(Design.state.label.headline6) }

   var title: LabelModel { .init(Design.state.label.title) }
   var title2: LabelModel { .init(Design.state.label.title2) }

   var subtitle: LabelModel { .init(Design.state.label.subtitle) }
   var subtitleSecondary: LabelModel { .init(Design.state.label.subtitleSecondary) }

   var body1: LabelModel { .init(Design.state.label.body1) }
   var body2: LabelModel { .init(Design.state.label.body2) }
   var body3: LabelModel { .init(Design.state.label.body3) }
   var body4: LabelModel { .init(Design.state.label.body4) }

   var caption: LabelModel { .init(Design.state.label.caption) }
   var captionSecondary: LabelModel { .init(Design.state.label.captionSecondary) }

   var captionError: LabelModel { .init(Design.state.label.captionError) }
   var caption2: LabelModel { .init(Design.state.label.caption2) }
   var counter: LabelModel { .init(Design.state.label.counter) }
}

protocol LabelStateProtocol: TypographyElements where DesignElement == [LabelState] {}

struct LabelStateBuilder<Design: DSP>: LabelStateProtocol, Designable {
   var `default`: [LabelState] { [
      .font(.systemFont(ofSize: 14, weight: .regular)),
      .textColor(Design.color.text)
   ] }

   var defaultBrand: [LabelState] { [
      .font(.systemFont(ofSize: 14, weight: .regular)),
      .textColor(Design.color.textBrand)
   ] }

   var defaultError: [LabelState] { [
      .font(.systemFont(ofSize: 14, weight: .regular)),
      .textColor(Design.color.textError)
   ] }

   var headline2: [LabelState] { [
      .font(.systemFont(ofSize: 54, weight: .semibold)),
      .textColor(Design.color.text)
   ] }

   var headline3: [LabelState] { [
      .font(.systemFont(ofSize: 48, weight: .regular)),
      .textColor(Design.color.text)
   ] }

   var headline4: [LabelState] { [
      .font(.systemFont(ofSize: 32, weight: .bold)),
      .textColor(Design.color.text)
   ] }

   var headline5: [LabelState] { [
      .font(.systemFont(ofSize: 28, weight: .bold)),
      .textColor(Design.color.text)
   ] }

   var headline6: [LabelState] { [
      .font(.systemFont(ofSize: 20, weight: .regular)),
      .textColor(Design.color.text)
   ] }

   var title: [LabelState] { [
      .font(.systemFont(ofSize: 24, weight: .bold)),
      .textColor(Design.color.text)
   ] }

   var title2: [LabelState] { [
      .font(.systemFont(ofSize: 24, weight: .medium)),
      .textColor(Design.color.text)
   ] }

   var body1: [LabelState] { [
      .font(.systemFont(ofSize: 16, weight: .regular)),
      .textColor(Design.color.text)
   ] }

   var body2: [LabelState] { [
      .font(.systemFont(ofSize: 14, weight: .semibold)),
      .textColor(Design.color.text)
   ] }

   var body3: [LabelState] { [
      .font(.systemFont(ofSize: 16, weight: .semibold)),
      .textColor(Design.color.text)
   ] }

   var body4: [LabelState] { [
      .font(.systemFont(ofSize: 16, weight: .medium)),
      .textColor(Design.color.text)
   ] }

   var subtitle: [LabelState] { [
      .font(.systemFont(ofSize: 16, weight: .regular)),
      .textColor(Design.color.text)
   ] }

   var subtitleSecondary: [LabelState] { [
      .font(.systemFont(ofSize: 16, weight: .regular)),
      .textColor(Design.color.textSecondary)
   ] }

   var caption: [LabelState] { [
      .font(.systemFont(ofSize: 12, weight: .regular)),
      .textColor(Design.color.text)
   ] }

   var captionSecondary: [LabelState] { [
      .font(.systemFont(ofSize: 12, weight: .regular)),
      .textColor(Design.color.textSecondary)
   ] }

   var captionError: [LabelState] { [
      .font(.systemFont(ofSize: 12, weight: .regular)),
      .textColor(Design.color.textError)
   ] }

   var caption2: [LabelState] { [
      .font(.systemFont(ofSize: 10, weight: .regular)),
      .textColor(Design.color.text)
   ] }

   var counter: [LabelState] { [
      .font(.systemFont(ofSize: 48, weight: .regular)),
      .textColor(Design.color.text)
   ] }
}
