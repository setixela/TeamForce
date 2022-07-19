//
//  ViewModel+Stateable.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.07.2022.
//

import UIKit

enum ViewState {
    case backColor(UIColor)
    case cornerRadius(CGFloat)
    case borderWidth(CGFloat)
    case borderColor(UIColor)
    case height(CGFloat)
    case hidden(Bool)
}

enum StackState {
    case distribution(UIStackView.Distribution)
    case axis(NSLayoutConstraint.Axis)
    case spacing(CGFloat)
    case alignment(UIStackView.Alignment)
    case padding(UIEdgeInsets)
    case backColor(UIColor)
    case cornerRadius(CGFloat)
    case borderWidth(CGFloat)
    case borderColor(UIColor)
    case height(CGFloat)
    case models([UIViewModel])
    case hidden(Bool)
}

// MARK: -  Stateable extensions

extension ViewModelProtocol where Self: Stateable {
    func applyState(_ state: ViewState) {
        switch state {
        case .backColor(let value):
            view.backgroundColor = value
        case .height(let value):
            view.addAnchors.constHeight(value)
        case .cornerRadius(let value):
            view.layer.cornerRadius = value
        case .borderColor(let value):
            view.layer.borderColor = value.cgColor
        case .borderWidth(let value):
            view.layer.borderWidth = value
        case .hidden(let value):
            view.isHidden = value
        }
    }
}

// MARK: -  Stateable extensions

extension ViewModelProtocol where Self: Stateable, View: UIStackView {
    func applyState(_ state: StackState) {
        switch state {
        case .distribution(let value):
            view.distribution = value
        case .axis(let value):
            view.axis = value
        case .spacing(let value):
            view.spacing = value
        case .alignment(let value):
            view.alignment = value
        case .padding(let value):
            view.layoutMargins = value
            view.isLayoutMarginsRelativeArrangement = true
        case .backColor(let value):
            view.backgroundColor = value
        case .height(let value):
            view.addAnchors.constHeight(value)
        case .models(let models):
            view.subviews.forEach {
                $0.removeFromSuperview()
            }
            models.forEach {
                view.addArrangedSubview($0.uiView)
            }
        case .cornerRadius(let value):
            view.layer.cornerRadius = value
        case .borderColor(let value):
            view.layer.borderColor = value.cgColor
        case .borderWidth(let value):
            view.layer.borderWidth = value
        case .hidden(let value):
            view.isHidden = value
        }
    }
}
