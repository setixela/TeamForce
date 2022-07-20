//
//  ViewModelProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.05.2022.
//

import UIKit

// Associatedtype View Erasing protocol
protocol UIViewModel: ModelProtocol {
    var uiView: UIView { get }
}

protocol ViewModelProtocol: UIViewModel {
    associatedtype View: UIView

    var view: View { get }

    init()
}

class BaseViewModel<View: UIView>: NSObject, ViewModelProtocol {
    private weak var weakView: View?

    // will be cleaned after presenting view
    private var autostartedView: View?
    private var isAutoreleaseView = false

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
        if isAutoreleaseView, let readyView = autostartedView {
            autostartedView = nil
            return readyView
        }
        return view
    }

    override required init() {
        super.init()
//
//        view
    }

    convenience init(isAutoreleaseView: Bool) {
        self.init()
        self.isAutoreleaseView = isAutoreleaseView
    }

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

extension UIViewModel {
    func setupBackgroundImage(name: String) {
       let backgroundImage = UIImageView()
       let screenSize: CGRect = UIScreen.main.bounds
       backgroundImage.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height * 0.7)
       backgroundImage.image = UIImage(named: name)
       backgroundImage.contentMode = .scaleAspectFit
       uiView.insertSubview(backgroundImage, at: 0)
    }
}
