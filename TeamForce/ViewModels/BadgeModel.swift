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
    
    internal let titleLabel = LabelModel()
        .set(.text(Text.title.make(\.userName)))
        .set(.numberOfLines(1))
        .set(.font(Design.font.caption))
        .set(.isHidden(true))
    
    internal let errorLabel = LabelModel()
        .set(.text(Text.title.make(\.wrongUsername)))
        .set(.font(Design.font.caption))
        .set(.isHidden(true))
    
    override func start() {
        set(.distribution(.fill))
        set(.alignment(.fill))
        set(.axis(.vertical))
        set(.models([
           titleLabel,
           textFieldModel,
           errorLabel
        ]))
        
        
        
    }
}

extension BadgeModel: Stateable {}
