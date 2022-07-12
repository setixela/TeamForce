//
//  LabelStateBuilder.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 10.07.2022.
//

import UIKit

protocol LabelStateBuilderProtocol: TypographyProtocol {
    associatedtype Fonts: FontBuilderProtocol
}

struct LabelStateBuilder: LabelStateBuilderProtocol {
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
