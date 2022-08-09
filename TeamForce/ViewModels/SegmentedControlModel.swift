//
//  SegmentedControlModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 09.08.2022.
//

import UIKit
import ReactiveWorks

struct SegmentedControlEvent: InitProtocol {
    var segmentChanged: Event<Int>?
}

enum SegmentedControlState {
    case items([String])
    case selectedSegmentIndex(Int)
    case selectedSegmentTintColor(UIColor)
    case height(CGFloat)
    case width(CGFloat)
}

final class SegmentedControlModel: BaseViewModel<UISegmentedControl>,
                                    Communicable {
    var eventsStore = SegmentedControlEvent()

    private var items: [String] = []

    override func start() {
        view.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        print("index \(sender.selectedSegmentIndex)")
        sendEvent(\.segmentChanged, sender.selectedSegmentIndex)
    }
    func getSelectedIndex() -> Int {
        return view.selectedSegmentIndex
    }
}

extension SegmentedControlModel: Stateable2 {
    typealias State = SegmentedControlState

    func applyState(_ state: SegmentedControlState) {
        switch state {
        case .items(let items):
            for i in 0..<items.count {
                view.insertSegment(withTitle: items[i], at: i, animated: false)
            }
        case .selectedSegmentIndex(let value):
            view.selectedSegmentIndex = value
        case .selectedSegmentTintColor(let value):
            view.selectedSegmentTintColor = value
        case .height(let value):
            view.addAnchors.constHeight(value)
        case .width(let value):
            view.addAnchors.constWidth(value)
        }
    }
}
