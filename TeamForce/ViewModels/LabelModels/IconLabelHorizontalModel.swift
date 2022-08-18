//
//  IconLabelHorizontalModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import UIKit
import ReactiveWorks

enum IconLabelState {
    case icon(UIImage)
    case text(String)
}

struct IconLabelHorizontalModelEvents: InitProtocol {
   var didTap: Event<Void>?
}

final class IconLabelHorizontalModel<Asset: AssetProtocol>: BaseViewModel<StackViewExtended>,
    Assetable, Communicable
{
    var eventsStore: IconLabelHorizontalModelEvents = .init()
    
    let label = Design.label.body2
    let icon = ImageViewModel()

    required init() {
        super.init()
    }

    override func start() {
        set(.axis(.horizontal))
        set(.distribution(.fill))
        set(.alignment(.center))
        set(.models([
            icon,
            Spacer(20),
            label,
            Spacer()
        ]))
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.clickAction(sender:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func clickAction(sender : UITapGestureRecognizer) {
        sendEvent(\.didTap)
        print("Did tap1")
    }
}

extension IconLabelHorizontalModel: Stateable2 {
    typealias State = StackState

    func applyState(_ state: IconLabelState) {
        switch state {
        case .icon(let uIImage):
            icon.set(.image(uIImage))
        case .text(let string):
            label.set(.text(string))
        }
    }
}
