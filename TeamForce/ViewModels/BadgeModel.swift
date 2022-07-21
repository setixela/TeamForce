//
//  BadgeModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 21.07.2022.
//

import UIKit

class BadgeModel<Asset: AssetProtocol>: BaseViewModel<UIStackView>, Assetable {
    
    internal var textFieldModel = TextFieldModel()
       .set(.padding(.init(top: 16, left: 16, bottom: 16, right: 16)))
       .set(.placeholder("@" + Text.title.make(\.userName)))
       .set(.backColor(UIColor.clear))
       .set(.borderColor(.lightGray.withAlphaComponent(0.4)))
       .set(.borderWidth(1.0))
    
    private let titleLabel = LabelModel()
        .set(.text(Text.title.make(\.userName)))
        .set(.numberOfLines(1))
    
    private let errorLabel = LabelModel()
        .set(.text(Text.title.make(\.wrongUsername)))
    override func start() {
        set(.distribution(.fill))
        set(.alignment(.fill))
        set(.axis(.vertical))
        set(.models([
           titleLabel,
           textFieldModel,
           errorLabel
        ]))
        
        titleLabel
           .set(.font(Design.font.caption))
        errorLabel
            .set(.font(Design.font.caption))
    }
}

extension BadgeModel: Stateable {}
