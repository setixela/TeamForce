//
//  Labels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 23.06.2022.
//

import UIKit

// MARK: - Labels Protocol

protocol LabelsProtocol {
    associatedtype DesignType

    var `default`: DesignType { get }

    var headline3: DesignType { get }
    var headline4: DesignType { get }
    var headline5: DesignType { get }
    var headline6: DesignType { get }

    var title: DesignType { get }
    var body1: DesignType { get }
    var body2: DesignType { get }
    var subtitle: DesignType { get }
    var caption: DesignType { get }
    var counter: DesignType { get }
}

protocol LabelStateBuilderProtocol: LabelsProtocol {
    associatedtype Parameters: ParametersProtocol
}

protocol LabelBuilderProtocol: LabelsProtocol,
                               BuilderProtocol where Builder: LabelStateBuilderProtocol, DesignType == LabelModel {}

// MARK: - Labels

struct LabelStateBuilder: LabelStateBuilderProtocol {
    var `default`: [LabelState] { [
        .font(UIFont.systemFont(ofSize: 14, weight: .regular)),
        .color(.black)
    ] }

    var headline3: [LabelState] { [
        .font(UIFont.systemFont(ofSize: 48, weight: .regular)),
        .color(.black)
    ] }

    var headline4: [LabelState] { [
        .font(UIFont.systemFont(ofSize: 34, weight: .regular)),
        .color(.black)
    ] }

    var headline5: [LabelState] { [
        .font(UIFont.systemFont(ofSize: 24, weight: .regular)),
        .color(.black)
    ] }

    var headline6: [LabelState] { [
        .font(UIFont.systemFont(ofSize: 20, weight: .regular)),
        .color(.black)
    ] }

    var title: [LabelState] { [
        .font(UIFont.systemFont(ofSize: 24, weight: .bold)),
        .color(.black)
    ] }

    var body1: [LabelState] { [
        .font(UIFont.systemFont(ofSize: 16, weight: .regular)),
        .color(.black)
    ] }

    var body2: [LabelState] { [
        .font(UIFont.systemFont(ofSize: 14, weight: .regular)),
        .color(.black)
    ] }

    var subtitle: [LabelState] { [
        .font(UIFont.systemFont(ofSize: 16, weight: .regular)),
        .color(.black)
    ] }

    var caption: [LabelState] { [
        .font(UIFont.systemFont(ofSize: 12, weight: .regular)),
        .color(.black)
    ] }

    var counter: [LabelState] { [
        .font(UIFont.systemFont(ofSize: 48, weight: .regular)),
        .color(.black)
    ] }

    typealias Parameters = GlobalParameters
}

final class LabelBuilder: LabelBuilderProtocol {
    lazy var builder = LabelStateBuilder()

    var subtitle: LabelModel { .init(builder.subtitle) }
    var `default`: LabelModel { .init(builder.default) }

    var headline3: LabelModel { .init(builder.headline3) }
    var headline4: LabelModel { .init(builder.headline4) }
    var headline5: LabelModel { .init(builder.headline5) }
    var headline6: LabelModel { .init(builder.headline6) }

    var title: LabelModel { .init(builder.title) }
    var body1: LabelModel { .init(builder.body1) }
    var body2: LabelModel { .init(builder.body2) }
    var caption: LabelModel { .init(builder.caption) }
    var counter: LabelModel { .init(builder.counter) }
}
