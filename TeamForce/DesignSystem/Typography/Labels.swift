//
//  Labels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 23.06.2022.
//

import UIKit

// MARK: - Labels Protocol

protocol LabelBuilderProtocol: TypographyProtocol,
    BuilderProtocol where Builder: LabelStateBuilderProtocol, DesignType == LabelModel {}

// MARK: - Labels


final class LabelBuilder: LabelBuilderProtocol {
    lazy var builder = LabelStateBuilder()

    var subtitle: LabelModel { .init(builder.subtitle) }
    var `default`: LabelModel { .init(builder.default) }

    var headline2: LabelModel { .init(builder.headline2) }
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
