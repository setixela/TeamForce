//
//  BaseVCModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 04.06.2022.
//

import UIKit

struct VCEvent: InitProtocol {
    var viewDidLoad: Event<Void>?
    var viewWillAppear: Event<Void>?
    var viewWillDissappear: Event<Void>?

    // setup
    var setTitle: Event<String>?
}

protocol VCModelProtocol: UIViewController {
    var sceneModel: SceneModelProtocol { get }

    init(sceneModel: SceneModelProtocol)
}

class BaseVCModel: UIViewController, VCModelProtocol {
    let sceneModel: SceneModelProtocol

    lazy var baseView: UIView = sceneModel.makeMainView()

    var eventsStore: VCEvent = .init()

    required init(sceneModel: SceneModelProtocol) {
        self.sceneModel = sceneModel

        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = baseView
        view.backgroundColor = .white
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
