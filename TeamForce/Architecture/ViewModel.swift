//
//  ViewModelProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.05.2022.
//

import UIKit

// Associatedtype View Erasing protocol
protocol UIViewModel {
    var uiView: UIView { get }
}

protocol ViewModelProtocol: UIViewModel, ModelProtocol {
    associatedtype View: UIView

    var view: View { get }

    init()
}

class BaseViewModel<View: UIView>: NSObject, ViewModelProtocol {
    private weak var weakView: View?

    // will be cleaned after presenting view
    private var autostartedView: View?

    var view: View {
        if let view = weakView {
            return view
        } else {
            let view = View(frame: .zero)
            weakView = view
            autostartedView = view
            start()
            return view
        }
    }

    var uiView: UIView {
        if let readyView = autostartedView {
            autostartedView = nil
            return readyView
        }
        return view
    }

    override required init() {
        super.init()

        view
    }

//    convenience init(autostart: Bool) {
//        self.init()
//        if autostart {
//            autostartedView = view
//            weakView = view
//        }
//    }

    func start() {}

    func setupView(_ closure: GenericClosure<View>) {
        closure(view)
    }
}

extension UIViewModel where Self: Stateable {
    init(state: State) {
        self.init(state)
    }
}
