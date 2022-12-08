//
//  PickerViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 09.07.2022.
//

import ReactiveWorks
import UIKit

struct PickerViewEvent: InitProtocol {
   var didSelectRow: Event<Int>?
}

enum PickerViewState {
   case items([String])
}

final class PickerViewModel: BaseViewModel<UIPickerView> {
   var events = PickerViewEvent()

   private var items: [String] = []
   var selectedItem: String?
   var textField = TextFieldModel()
   override func start() {
      view.dataSource = self
      view.delegate = self
      textField.view.inputView = self.view
      dismissPickerView()
   }
   
   func attachToTextField(textField: TextFieldModel) {
      self.textField = textField
   }

   func dismissPickerView() {
      let toolBar = UIToolbar()
      toolBar.sizeToFit()

      let button = UIBarButtonItem(title: "Выбрать", style: .plain, target: self, action: #selector(self.action))
      toolBar.setItems([button], animated: true)
      toolBar.isUserInteractionEnabled = true
      textField.view.inputAccessoryView = toolBar
   }

   @objc func action() {
      textField.view.endEditing(true)
   }
}

extension PickerViewModel: Communicable {}

extension PickerViewModel: UIPickerViewDelegate {
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      items[row]
   }

//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 30
//    }

   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      selectedItem = items[row]
      textField.view.text = selectedItem
      sendEvent(\.didSelectRow, row)
   }
}

extension PickerViewModel: UIPickerViewDataSource {
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      1
   }

   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      items.count
   }
}

extension PickerViewModel: Stateable2 {
   func applyState(_ state: PickerViewState) {
      switch state {
      case .items(let array):
         items = array
         view.reloadAllComponents()
      }
   }

   typealias State = ViewState
   typealias State2 = PickerViewState
}
