//
//  Scene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.05.2022.
//

import UIKit

protocol SceneModelProtocol: ModelProtocol {
    func makeVC() -> UIViewController
    func makeMainView() -> UIView
    func setInput(_ value: Any?)
}

protocol SceneModel: SceneModelProtocol {
    associatedtype VCModel: VCModelProtocol
    associatedtype MainViewModel: ViewModelProtocol

    var vcModel: VCModel? { get set }
    var mainViewModel: MainViewModel { get }
}

struct SceneEvent<Input>: InitProtocol {
    var input: Event<Input>?
}

protocol Assetable {
    associatedtype Asset: AssetProtocol

    typealias Design = Asset.Design
    typealias Service = Asset.Service
    typealias Scene = Asset.Scene
  //  typealias Text = Asset.Text
}

class BaseSceneModel<VCModel: VCModelProtocol,
    MainViewModel: ViewModelProtocol,
    Asset: AssetProtocol,
    Input>: SceneModel
{
    private var _inputValue: Any?

    lazy var mainViewModel = MainViewModel()
    
    weak var vcModel: VCModel?

    var inputValue: Input? { _inputValue as? Input }

    var eventsStore: Events = .init()

    var text = Asset.Text()

    var icon = Asset.Design.Icon()

    func start() {
        print("Needs to override start()")
    }

//    func makeVM<T: ViewModelProtocol>() -> T {
//        let model = T()
//        _ = model.view // Make view
//        return model
//    }

    func setInput(_ value: Any? = nil) {
        _inputValue = value
    }
}

extension BaseSceneModel {
    func makeVC() -> UIViewController {
        let model = VCModel(sceneModel: self)
        vcModel = model
//        start()
        return model
    }

    func makeMainView() -> UIView {
        let view = mainViewModel.uiView
        start()
        return view
    }
}

extension BaseSceneModel: Communicable, Assetable {
    typealias Events = SceneEvent<Input>
}
