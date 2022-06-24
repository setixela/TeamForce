//
//  DesignSystemProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.06.2022.
//

import UIKit

protocol DesignSystemProtocol {
    associatedtype Label: LabelBuilderProtocol
    associatedtype Button: ButtonBuilderProtocol
    associatedtype State: ModelSetuperProtocol
    associatedtype Icon: IconsProtocol

    static var button: Button { get }
    static var label: Label { get }
}

protocol ParametersProtocol {
    static var cornerRadius: CGFloat { get }
}

protocol ModelSetuperProtocol {
    associatedtype MainView: MainViewSetuperProtocol
    associatedtype Button: ButtonStateBuilderProtocol

    static var mainView: MainView { get }
    static var button: Button { get }
}

protocol MainViewSetuperProtocol: InitProtocol {
    var `default`: StackState { get }
}


