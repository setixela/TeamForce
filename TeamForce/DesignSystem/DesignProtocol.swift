//
//  DesignSystemProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.06.2022.
//

import UIKit

protocol DesignProtocol: InitProtocol {
    associatedtype Font: FontBuilderProtocol
    associatedtype Label: LabelBuilderProtocol
    associatedtype Button: ButtonBuilderProtocol
    associatedtype State: ModelSetuperProtocol
    associatedtype Icon: IconsProtocol
    associatedtype Parameters: ParametersProtocol
    associatedtype Color: ColorsProtocol

    static var font: Font { get }
    static var label: Label { get }
    static var button: Button { get }
    static var icon: Icon { get }
    static var color: Color { get }
}

extension DesignProtocol {
    static var font: Font { .init() }
    static var label: Label { .init() }
    static var button: Button { .init() }
    static var icon: Icon { .init() }
    static var color: Color { .init() }
}

protocol ParametersProtocol {
    static var cornerRadius: CGFloat { get }
    static var contentPadding: UIEdgeInsets { get }
}

protocol ModelSetuperProtocol {
    associatedtype MainView: MainViewSetuperProtocol
    associatedtype Button: ButtonStateBuilderProtocol

    static var mainView: MainView { get }
    static var button: Button { get }
}

extension ModelSetuperProtocol {
    static var mainView: MainView { .init() }
    static var button: Button { .init() }
}

protocol MainViewSetuperProtocol: InitProtocol {
    var `default`: [StackState] { get }
}
