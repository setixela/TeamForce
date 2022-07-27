//
//  CustomCellModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 27.07.2022.
//

import UIKit

enum CustomCellState {
    case title(String)
    case text(String)
}

final class CustomCellModel<Design: DesignProtocol>: BaseViewModel<UIStackView>,
    Designable
{
    let title = LabelModel()
        .set(.font(Design.font.caption))
    let label = LabelModel()

    required init() {
        super.init(isAutoreleaseView: true)
    }
    
    init(title: String, label: String) {
        super.init()
        self.title.set(.text(title))
        self.label.set(.text(label))
    }

    override func start() {
//        view.backgroundColor = 
        set(.axis(.vertical))
        set(.models([title,
                     label]))
        set(.height(44))
    }
}

extension CustomCellModel: Stateable2 {
    typealias State = StackState

    func applyState(_ state: CustomCellState) {
        switch state {
        case .text(let string):
            label.set(.text(string))
        case .title(let string):
            title.set(.text(string))
        }
    }
}
