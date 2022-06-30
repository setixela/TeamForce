//
//  VlerProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.05.2022.
//

import UIKit

final class DefaultVCModel: BaseVCModel {
    required init(sceneModel: SceneModelProtocol) {
        super.init(sceneModel: sceneModel)

        onEvent(\.setTitle) { [weak self] title in
            self?.title = title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendEvent(\.viewDidLoad)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        sendEvent(\.viewWillAppear)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sendEvent(\.viewWillDissappear)
    }
}

//extension DefaultVCModel: Communicable {
//    typealias Events = VCEvent
//}
