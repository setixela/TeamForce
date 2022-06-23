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
    var title: DesignType { get }
    var subtitle: DesignType { get }
}

protocol LabelStateBuilderProtocol: LabelsProtocol {
    associatedtype Parameters: ParametersProtocol
}

protocol LabelBuilderProtocol: LabelsProtocol,
    BuilderProtocol where Builder: LabelStateBuilderProtocol {}

// MARK: - Labels

struct LabelStateBuilder: LabelStateBuilderProtocol {
    var `default`: LabelState {
        LabelState()
            .set(\.font, UIFont.systemFont(ofSize: 14, weight: .regular))
            .set(\.color, .black)
    }

    var headline3: LabelState {
        LabelState()
            .set(\.font, UIFont.systemFont(ofSize: 48, weight: .regular))
            .set(\.color, .black)
    }

    var headline4: LabelState {
        LabelState()
            .set(\.font, UIFont.systemFont(ofSize: 34, weight: .regular))
            .set(\.color, .black)
    }

    var headline5: LabelState {
        LabelState()
            .set(\.font, UIFont.systemFont(ofSize: 24, weight: .regular))
            .set(\.color, .black)
    }

    var title: LabelState {
        LabelState()
            .set(\.font, UIFont.systemFont(ofSize: 24, weight: .bold))
            .set(\.color, .black)
    }

    var subtitle: LabelState {
        LabelState()
            .set(\.font, UIFont.systemFont(ofSize: 16, weight: .regular))
            .set(\.color, .black)
    }

    typealias Parameters = GlobalParameters
}

final class LabelBuilder: LabelBuilderProtocol {
    lazy var builder = LabelStateBuilder()

    var subtitle: LabelModel {
        LabelModel(state: builder.subtitle)
    }

    var `default`: LabelModel {
        LabelModel(state: builder.default)
    }

    var headline3: LabelModel {
        LabelModel(state: builder.headline3)
    }

    var headline4: LabelModel {
        LabelModel(state: builder.headline4)
    }

    var headline5: LabelModel {
        LabelModel(state: builder.headline5)
    }

    var title: LabelModel {
        LabelModel(state: builder.title)
    }
}
